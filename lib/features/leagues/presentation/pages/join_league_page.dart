import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/state/providers/auth_state_provider.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../domain/entities/league_entity.dart';
import '../providers/join_league_provider.dart';

/// Page for joining a league via invite code
///
/// Allows users to enter an invite code, preview the league details,
/// and confirm joining the league.
class JoinLeaguePage extends ConsumerStatefulWidget {
  const JoinLeaguePage({super.key, this.initialCode});

  /// Optional initial invite code (e.g., from deep link)
  final String? initialCode;

  @override
  ConsumerState<JoinLeaguePage> createState() => _JoinLeaguePageState();
}

class _JoinLeaguePageState extends ConsumerState<JoinLeaguePage> {
  final _inviteCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.initialCode != null && widget.initialCode!.isNotEmpty) {
      _inviteCodeController.text = widget.initialCode!.toUpperCase();
      // Auto-search if initial code provided
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchLeague();
      });
    }
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  void _searchLeague() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(joinLeagueNotifierProvider.notifier)
          .searchByInviteCode(_inviteCodeController.text);
    }
  }

  Future<void> _joinLeague() async {
    final l10n = context.l10n;
    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.mustBeLoggedInToJoin),
        ),
      );
      return;
    }

    final success = await ref
        .read(joinLeagueNotifierProvider.notifier)
        .joinLeague(user.uid);

    if (success && mounted) {
      final league = ref.read(joinLeagueNotifierProvider).league;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.joinedLeagueSuccess(league?.name ?? '')),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      // Navigate to the league details page
      if (league != null) {
        context.push(
          AppRoutes.leagueDetails.replaceFirst(':leagueId', league.id),
        );
      } else {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(joinLeagueNotifierProvider);
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.joinLeagueTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header text
              Text(
                l10n.enterInviteCode,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapVerticalSm,
              Text(
                l10n.askAdminForCode,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapVerticalLg,

              // Invite code input form
              _InviteCodeForm(
                formKey: _formKey,
                controller: _inviteCodeController,
                isLoading: state.isLoading,
                onSearch: _searchLeague,
              ),

              // Error message
              if (state.status == JoinLeagueStatus.error) ...[
                AppSpacing.gapVerticalMd,
                _ErrorMessage(message: state.errorMessage ?? l10n.unknownError),
              ],

              // League preview
              if (state.hasLeague &&
                  (state.status == JoinLeagueStatus.previewReady ||
                      state.status == JoinLeagueStatus.joining ||
                      state.status == JoinLeagueStatus.success)) ...[
                AppSpacing.gapVerticalLg,
                _LeaguePreview(
                  league: state.league!,
                  isJoining: state.status == JoinLeagueStatus.joining,
                  hasJoined: state.status == JoinLeagueStatus.success,
                  onJoin: _joinLeague,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Form for entering the invite code
class _InviteCodeForm extends StatelessWidget {
  const _InviteCodeForm({
    required this.formKey,
    required this.controller,
    required this.isLoading,
    required this.onSearch,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            enabled: !isLoading,
            textCapitalization: TextCapitalization.characters,
            textAlign: TextAlign.center,
            maxLength: 8,
            style: theme.textTheme.headlineMedium?.copyWith(
              letterSpacing: 8,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'XXXXXXXX',
              hintStyle: theme.textTheme.headlineMedium?.copyWith(
                letterSpacing: 8,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              counterText: '',
              prefixIcon: const Icon(Icons.vpn_key),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              UpperCaseTextFormatter(),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.enterInviteCodeValidation;
              }
              if (value.length < 6 || value.length > 8) {
                return l10n.codeMustHaveChars;
              }
              return null;
            },
            onFieldSubmitted: (_) => onSearch(),
          ),
          AppSpacing.gapVerticalMd,
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isLoading ? null : onSearch,
              icon: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.search),
              label: Text(isLoading ? l10n.searching : l10n.searchLeague),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays error messages
class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
          ),
          AppSpacing.gapHorizontalSm,
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays the league preview card with join button
class _LeaguePreview extends StatelessWidget {
  const _LeaguePreview({
    required this.league,
    required this.isJoining,
    required this.hasJoined,
    required this.onJoin,
  });

  final LeagueEntity league;
  final bool isJoining;
  final bool hasJoined;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // League header
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.emoji_events,
                    size: 28,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                AppSpacing.gapHorizontalMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        league.name,
                        style: theme.textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (league.description != null &&
                          league.description!.isNotEmpty)
                        Text(
                          league.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),

            AppSpacing.gapVerticalMd,
            const Divider(),
            AppSpacing.gapVerticalMd,

            // League stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.people,
                  label: l10n.members,
                  value: '${league.memberCount}/${league.settings.maxMembers}',
                ),
                _StatItem(
                  icon: Icons.star,
                  label: l10n.pointsPerCheckIn,
                  value: '${league.settings.pointsPerCheckIn}',
                ),
                _StatItem(
                  icon: league.settings.isPublic
                      ? Icons.public
                      : Icons.lock_outline,
                  label: l10n.visibility,
                  value: league.settings.isPublic ? l10n.publicLabel : l10n.privateLabel,
                ),
              ],
            ),

            AppSpacing.gapVerticalLg,

            // Join button
            SizedBox(
              width: double.infinity,
              child: hasJoined
                  ? FilledButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check),
                      label: Text(l10n.youJoined),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                      ),
                    )
                  : FilledButton.icon(
                      onPressed: isJoining ? null : onJoin,
                      icon: isJoining
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.onPrimary,
                              ),
                            )
                          : const Icon(Icons.login),
                      label: Text(isJoining ? l10n.joining : l10n.joinTheLeague),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays a stat item with icon, label and value
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          size: AppSpacing.iconMd,
          color: theme.colorScheme.primary,
        ),
        AppSpacing.gapVerticalXs,
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Text input formatter that converts text to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
