import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/state/providers/auth_state_provider.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../providers/user_profile_provider.dart';

/// User profile page displaying avatar, name, email, statistics and actions
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final basicInfo = ref.watch(userBasicInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) => _ProfileContent(profile: profile),
        loading: () => basicInfo != null
            ? _ProfileContent(profile: basicInfo, isLoading: true)
            : const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text(
                context.l10n.errorLoadingProfile,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(userProfileProvider),
                child: Text(context.l10n.tryAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({
    required this.profile,
    this.isLoading = false,
  });

  final UserProfileData profile;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _ProfileAvatar(
            photoURL: profile.photoURL,
            displayName: profile.displayNameOrEmail,
          ),
          const SizedBox(height: 16),
          Text(
            profile.displayNameOrEmail,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            profile.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatCard(
                label: context.l10n.checkIns,
                value: isLoading ? '-' : profile.totalCheckIns.toString(),
                icon: Icons.restaurant,
                isLoading: isLoading,
              ),
              _StatCard(
                label: context.l10n.streak,
                value: isLoading
                    ? '-'
                    : profile.currentStreak > 0
                        ? '${profile.currentStreak}d'
                        : '0',
                icon: Icons.local_fire_department,
                isLoading: isLoading,
                highlight: profile.hasActiveStreak,
              ),
              _StatCard(
                label: context.l10n.leagues,
                value: isLoading ? '-' : profile.leaguesJoined.toString(),
                icon: Icons.emoji_events,
                isLoading: isLoading,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text(context.l10n.editProfile),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.editProfile),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(context.l10n.checkInHistory),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.checkIns),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.emoji_events),
                  title: Text(context.l10n.myLeagues),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.leagues),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                context.l10n.logout,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              onTap: () => _showLogoutConfirmation(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.logout),
        content: Text(context.l10n.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(authNotifierProvider.notifier).signOut();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.photoURL,
    required this.displayName,
  });

  final String? photoURL;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    if (photoURL != null && photoURL!.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: photoURL!,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => _buildInitialAvatar(context),
          ),
        ),
      );
    }

    return _buildInitialAvatar(context);
  }

  Widget _buildInitialAvatar(BuildContext context) {
    final initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: 50,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        initial,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.isLoading = false,
    this.highlight = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isLoading;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final iconColor = highlight
        ? Colors.orange
        : Theme.of(context).colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(height: 8),
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            else
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: highlight ? Colors.orange : null,
                    ),
              ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
