import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/state/providers/auth_state_provider.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../domain/entities/league_entity.dart';
import '../providers/create_league_provider.dart';

/// Page for creating a new league
///
/// Allows users to enter a league name, optional description,
/// and configure settings. Automatically generates an invite code
/// and shows success confirmation.
class CreateLeaguePage extends ConsumerStatefulWidget {
  const CreateLeaguePage({super.key});

  @override
  ConsumerState<CreateLeaguePage> createState() => _CreateLeaguePageState();
}

class _CreateLeaguePageState extends ConsumerState<CreateLeaguePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Settings state
  bool _isPublic = false;
  int _maxMembers = 50;
  bool _allowMemberInvites = true;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createLeague() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.mustBeLoggedIn),
        ),
      );
      return;
    }

    final settings = LeagueSettings(
      isPublic: _isPublic,
      maxMembers: _maxMembers,
      allowMemberInvites: _allowMemberInvites,
    );

    final success = await ref
        .read(createLeagueNotifierProvider.notifier)
        .createLeague(
          name: _nameController.text,
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null,
          createdBy: user.uid,
          settings: settings,
        );

    if (success && mounted) {
      final league = ref.read(createLeagueNotifierProvider).league;
      if (league != null) {
        // Show success dialog with invite code
        _showSuccessDialog(league);
      }
    }
  }

  void _showSuccessDialog(LeagueEntity league) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _SuccessDialog(
        league: league,
        onViewLeague: () {
          Navigator.of(context).pop();
          context.go(
            AppRoutes.leagueDetails.replaceFirst(':leagueId', league.id),
          );
        },
        onBackToLeagues: () {
          Navigator.of(context).pop();
          context.go(AppRoutes.leagues);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createLeagueNotifierProvider);
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createLeague),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Icon(
                  Icons.emoji_events,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.gapVerticalMd,
                Text(
                  l10n.createYourLeague,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapVerticalSm,
                Text(
                  l10n.createLeagueDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapVerticalXl,

                // Name field
                TextFormField(
                  controller: _nameController,
                  enabled: !state.isLoading,
                  maxLength: 50,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: '${l10n.leagueName} *',
                    hintText: l10n.leagueNameHint,
                    prefixIcon: const Icon(Icons.group),
                    counterText: '',
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.leagueNameRequired;
                    }
                    if (value.trim().length < 3) {
                      return l10n.minCharsRequired(3);
                    }
                    return null;
                  },
                ),
                AppSpacing.gapVerticalMd,

                // Description field
                TextFormField(
                  controller: _descriptionController,
                  enabled: !state.isLoading,
                  maxLength: 200,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: l10n.descriptionOptional,
                    hintText: l10n.describeYourLeague,
                    prefixIcon: const Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(200),
                  ],
                ),
                AppSpacing.gapVerticalLg,

                // Settings section
                Text(
                  l10n.configuration,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.gapVerticalSm,

                // Public/Private toggle
                Card(
                  child: SwitchListTile(
                    title: Text(l10n.publicLeague),
                    subtitle: Text(
                      _isPublic
                          ? l10n.anyoneCanFind
                          : l10n.inviteCodeOnly,
                      style: theme.textTheme.bodySmall,
                    ),
                    secondary: Icon(
                      _isPublic ? Icons.public : Icons.lock_outline,
                      color: theme.colorScheme.primary,
                    ),
                    value: _isPublic,
                    onChanged: state.isLoading
                        ? null
                        : (value) => setState(() => _isPublic = value),
                  ),
                ),
                AppSpacing.gapVerticalSm,

                // Allow member invites toggle
                Card(
                  child: SwitchListTile(
                    title: Text(l10n.membersCanInvite),
                    subtitle: Text(
                      _allowMemberInvites
                          ? l10n.allMembersCanShare
                          : l10n.onlyAdminsCanInvite,
                      style: theme.textTheme.bodySmall,
                    ),
                    secondary: Icon(
                      Icons.person_add,
                      color: theme.colorScheme.primary,
                    ),
                    value: _allowMemberInvites,
                    onChanged: state.isLoading
                        ? null
                        : (value) => setState(() => _allowMemberInvites = value),
                  ),
                ),
                AppSpacing.gapVerticalSm,

                // Max members slider
                Card(
                  child: Padding(
                    padding: AppSpacing.cardPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: theme.colorScheme.primary,
                            ),
                            AppSpacing.gapHorizontalMd,
                            Expanded(
                              child: Text(
                                l10n.maxMembers,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                            Text(
                              '$_maxMembers',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _maxMembers.toDouble(),
                          min: 2,
                          max: 100,
                          divisions: 49,
                          label: '$_maxMembers',
                          onChanged: state.isLoading
                              ? null
                              : (value) =>
                                  setState(() => _maxMembers = value.round()),
                        ),
                        Text(
                          l10n.fromToMembers(2, 100),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Error message
                if (state.hasError) ...[
                  AppSpacing.gapVerticalMd,
                  _ErrorMessage(message: state.errorMessage ?? l10n.unknownError),
                ],

                AppSpacing.gapVerticalXl,

                // Create button
                FilledButton.icon(
                  onPressed: state.isLoading ? null : _createLeague,
                  icon: state.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : const Icon(Icons.add),
                  label: Text(state.isLoading ? l10n.creating : l10n.createLeague),
                ),

                AppSpacing.gapVerticalMd,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Success dialog showing the created league and invite code
class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog({
    required this.league,
    required this.onViewLeague,
    required this.onBackToLeagues,
  });

  final LeagueEntity league;
  final VoidCallback onViewLeague;
  final VoidCallback onBackToLeagues;

  void _copyInviteCode(BuildContext context) {
    final l10n = context.l10n;
    Clipboard.setData(ClipboardData(text: league.inviteCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.codeCopied),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AlertDialog(
      icon: Icon(
        Icons.check_circle,
        size: 64,
        color: theme.colorScheme.primary,
      ),
      title: Text(l10n.leagueCreated),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.leagueCreatedSuccess(league.name),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapVerticalLg,
          Text(
            l10n.inviteCode,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapVerticalSm,
          InkWell(
            onTap: () => _copyInviteCode(context),
            borderRadius: AppSpacing.borderRadiusMd,
            child: Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    league.inviteCode,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  AppSpacing.gapHorizontalMd,
                  Icon(
                    Icons.copy,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.gapVerticalSm,
          Text(
            l10n.tapToCopy,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapVerticalMd,
          Text(
            l10n.shareInviteCode,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onBackToLeagues,
          child: Text(l10n.back),
        ),
        FilledButton(
          onPressed: onViewLeague,
          child: Text(l10n.viewLeague),
        ),
      ],
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
