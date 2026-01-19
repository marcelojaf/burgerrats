import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/state/providers/auth_state_provider.dart';
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
        const SnackBar(
          content: Text('Voce precisa estar logado para criar uma liga'),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Liga'),
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
                  'Crie sua liga',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapVerticalSm,
                Text(
                  'Reuna seus amigos e compitam para encontrar os melhores hamburgueres!',
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
                  decoration: const InputDecoration(
                    labelText: 'Nome da Liga *',
                    hintText: 'Ex: Burguer Hunters',
                    prefixIcon: Icon(Icons.group),
                    counterText: '',
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nome da liga e obrigatorio';
                    }
                    if (value.trim().length < 3) {
                      return 'Minimo de 3 caracteres';
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
                  decoration: const InputDecoration(
                    labelText: 'Descricao (opcional)',
                    hintText: 'Descreva sua liga...',
                    prefixIcon: Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(200),
                  ],
                ),
                AppSpacing.gapVerticalLg,

                // Settings section
                Text(
                  'Configuracoes',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.gapVerticalSm,

                // Public/Private toggle
                Card(
                  child: SwitchListTile(
                    title: const Text('Liga Publica'),
                    subtitle: Text(
                      _isPublic
                          ? 'Qualquer um pode encontrar sua liga'
                          : 'Apenas com codigo de convite',
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
                    title: const Text('Membros podem convidar'),
                    subtitle: Text(
                      _allowMemberInvites
                          ? 'Todos membros podem compartilhar o codigo'
                          : 'Apenas administradores podem convidar',
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
                                'Maximo de membros',
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
                          'De 2 a 100 membros',
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
                  _ErrorMessage(message: state.errorMessage ?? 'Erro desconhecido'),
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
                  label: Text(state.isLoading ? 'Criando...' : 'Criar Liga'),
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
    Clipboard.setData(ClipboardData(text: league.inviteCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Codigo copiado!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      icon: Icon(
        Icons.check_circle,
        size: 64,
        color: theme.colorScheme.primary,
      ),
      title: const Text('Liga Criada!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sua liga "${league.name}" foi criada com sucesso!',
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapVerticalLg,
          Text(
            'Codigo de Convite',
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
            'Toque para copiar',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapVerticalMd,
          Text(
            'Compartilhe este codigo com seus amigos para que eles possam entrar na sua liga!',
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
          child: const Text('Voltar'),
        ),
        FilledButton(
          onPressed: onViewLeague,
          child: const Text('Ver Liga'),
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
