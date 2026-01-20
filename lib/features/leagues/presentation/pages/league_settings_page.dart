import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/state/providers/auth_state_provider.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/user_repository.dart';
import '../../domain/entities/league_entity.dart';
import '../../domain/repositories/league_repository.dart';
import '../providers/leaderboard_provider.dart';

/// Provider for user profiles cache in settings page
final _settingsUserProfilesCacheProvider =
    StateProvider.family<Map<String, UserEntity?>, String>(
  (ref, leagueId) => {},
);

/// Provider to load user profiles for settings page
final _loadSettingsUserProfilesProvider =
    FutureProvider.family<void, String>((ref, leagueId) async {
  final leagueAsync = ref.watch(leagueStreamProvider(leagueId));
  final league = leagueAsync.valueOrNull;

  if (league == null) return;

  final userRepository = getIt<UserRepository>();
  final profiles = <String, UserEntity?>{};

  for (final member in league.members) {
    try {
      profiles[member.userId] = await userRepository.getUserById(member.userId);
    } catch (_) {
      profiles[member.userId] = null;
    }
  }

  ref.read(_settingsUserProfilesCacheProvider(leagueId).notifier).state =
      profiles;
});

/// League settings page for admins to manage league configuration and members
class LeagueSettingsPage extends ConsumerStatefulWidget {
  const LeagueSettingsPage({
    super.key,
    required this.leagueId,
  });

  final String leagueId;

  @override
  ConsumerState<LeagueSettingsPage> createState() => _LeagueSettingsPageState();
}

class _LeagueSettingsPageState extends ConsumerState<LeagueSettingsPage> {
  bool _isPerformingAction = false;
  String? _actionMessage;

  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Settings state
  bool _isPublic = false;
  int _maxMembers = 50;
  int _pointsPerCheckIn = 10;
  int _pointsPerReview = 5;
  bool _allowMemberInvites = true;
  bool _requireApproval = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(_loadSettingsUserProfilesProvider(widget.leagueId));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initializeFormWithLeague(LeagueEntity league) {
    if (_nameController.text.isEmpty) {
      _nameController.text = league.name;
      _descriptionController.text = league.description ?? '';
      _isPublic = league.settings.isPublic;
      _maxMembers = league.settings.maxMembers;
      _pointsPerCheckIn = league.settings.pointsPerCheckIn;
      _pointsPerReview = league.settings.pointsPerReview;
      _allowMemberInvites = league.settings.allowMemberInvites;
      _requireApproval = league.settings.requireApproval;
    }
  }

  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  Future<void> _performAction(
    String message,
    Future<void> Function() action,
  ) async {
    setState(() {
      _isPerformingAction = true;
      _actionMessage = message;
    });

    try {
      await action();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPerformingAction = false;
          _actionMessage = null;
        });
      }
    }
  }

  Future<void> _saveChanges(String currentUserId) async {
    if (!_formKey.currentState!.validate()) return;

    await _performAction('Salvando alteracoes...', () async {
      final repository = getIt<LeagueRepository>();

      // First, get the current league to update it
      final league = await repository.getLeagueById(widget.leagueId);
      if (league == null) throw Exception('Liga nao encontrada');

      // Update the league with new name and description
      final updatedLeague = league.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );
      await repository.updateLeague(updatedLeague);

      // Update settings
      final newSettings = LeagueSettings(
        isPublic: _isPublic,
        maxMembers: _maxMembers,
        pointsPerCheckIn: _pointsPerCheckIn,
        pointsPerReview: _pointsPerReview,
        allowMemberInvites: _allowMemberInvites,
        requireApproval: _requireApproval,
      );
      await repository.updateLeagueSettings(
        leagueId: widget.leagueId,
        settings: newSettings,
        requesterId: currentUserId,
      );

      setState(() => _hasUnsavedChanges = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alteracoes salvas com sucesso!'),
          ),
        );
      }
    });
  }

  void _copyInviteCode(String inviteCode) {
    Clipboard.setData(ClipboardData(text: inviteCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Codigo copiado!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _confirmRegenerateCode(String currentUserId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gerar Novo Codigo'),
        content: const Text(
          'Deseja gerar um novo codigo de convite? O codigo antigo sera invalidado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _performAction('Gerando novo codigo...', () async {
                final repository = getIt<LeagueRepository>();
                await repository.regenerateInviteCode(
                  leagueId: widget.leagueId,
                  requesterId: currentUserId,
                );
              });
            },
            child: const Text('Gerar'),
          ),
        ],
      ),
    );
  }

  String _getMemberDisplayName(
      String userId, Map<String, UserEntity?> profiles) {
    final profile = profiles[userId];
    if (profile != null) {
      return profile.displayNameOrEmail;
    }
    return userId.length > 8 ? '${userId.substring(0, 8)}...' : userId;
  }

  String? _getMemberPhotoUrl(
      String userId, Map<String, UserEntity?> profiles) {
    return profiles[userId]?.photoURL;
  }

  String _getRoleLabel(LeagueMemberRole role) {
    return switch (role) {
      LeagueMemberRole.owner => 'Dono',
      LeagueMemberRole.admin => 'Admin',
      LeagueMemberRole.member => 'Membro',
    };
  }

  IconData _getRoleIcon(LeagueMemberRole role) {
    return switch (role) {
      LeagueMemberRole.owner => Icons.star,
      LeagueMemberRole.admin => Icons.verified_user,
      LeagueMemberRole.member => Icons.person,
    };
  }

  Color _getRoleColor(LeagueMemberRole role, BuildContext context) {
    return switch (role) {
      LeagueMemberRole.owner => Colors.amber,
      LeagueMemberRole.admin => Theme.of(context).colorScheme.primary,
      LeagueMemberRole.member =>
        Theme.of(context).colorScheme.onSurfaceVariant,
    };
  }

  void _confirmRemoveMember(
    String userId,
    Map<String, UserEntity?> profiles,
    String currentUserId,
  ) {
    final displayName = _getMemberDisplayName(userId, profiles);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Membro'),
        content: Text(
          'Deseja remover $displayName da liga? Esta acao nao pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(context);
              _performAction('Removendo membro...', () async {
                final repository = getIt<LeagueRepository>();
                await repository.removeMember(
                  leagueId: widget.leagueId,
                  userId: userId,
                  requesterId: currentUserId,
                );
              });
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  void _confirmPromoteMember(
    String userId,
    Map<String, UserEntity?> profiles,
    String currentUserId,
  ) {
    final displayName = _getMemberDisplayName(userId, profiles);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Promover a Admin'),
        content: Text(
          'Deseja promover $displayName a admin? Admins podem gerenciar membros da liga.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _performAction('Promovendo membro...', () async {
                final repository = getIt<LeagueRepository>();
                await repository.updateMemberRole(
                  leagueId: widget.leagueId,
                  userId: userId,
                  newRole: LeagueMemberRole.admin,
                  requesterId: currentUserId,
                );
              });
            },
            child: const Text('Promover'),
          ),
        ],
      ),
    );
  }

  void _confirmDemoteMember(
    String userId,
    Map<String, UserEntity?> profiles,
    String currentUserId,
  ) {
    final displayName = _getMemberDisplayName(userId, profiles);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Admin'),
        content: Text(
          'Deseja remover $displayName como admin? Ele permanecera como membro da liga.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _performAction('Removendo admin...', () async {
                final repository = getIt<LeagueRepository>();
                await repository.updateMemberRole(
                  leagueId: widget.leagueId,
                  userId: userId,
                  newRole: LeagueMemberRole.member,
                  requesterId: currentUserId,
                );
              });
            },
            child: const Text('Remover Admin'),
          ),
        ],
      ),
    );
  }

  void _showMemberActions(
    BuildContext context,
    LeagueMember member,
    LeagueEntity league,
    String currentUserId,
    Map<String, UserEntity?> profiles,
  ) {
    final isCurrentUserOwner = league.isOwner(currentUserId);
    final isMemberOwner = member.isOwner;
    final isMemberAdmin = member.isAdmin;
    final isCurrentUser = member.userId == currentUserId;

    // Can't perform actions on yourself or on owner
    if (isCurrentUser || isMemberOwner) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: _getMemberPhotoUrl(member.userId, profiles) !=
                        null
                    ? NetworkImage(_getMemberPhotoUrl(member.userId, profiles)!)
                    : null,
                child: _getMemberPhotoUrl(member.userId, profiles) == null
                    ? Text(_getMemberDisplayName(member.userId, profiles)
                        .substring(0, 1)
                        .toUpperCase())
                    : null,
              ),
              title: Text(_getMemberDisplayName(member.userId, profiles)),
              subtitle: Text(_getRoleLabel(member.role)),
            ),
            const Divider(),
            if (isCurrentUserOwner && !isMemberAdmin)
              ListTile(
                leading: const Icon(Icons.arrow_upward, color: Colors.green),
                title: const Text('Promover a Admin'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmPromoteMember(member.userId, profiles, currentUserId);
                },
              ),
            if (isCurrentUserOwner && isMemberAdmin && !isMemberOwner)
              ListTile(
                leading: const Icon(Icons.arrow_downward, color: Colors.orange),
                title: const Text('Remover Admin'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDemoteMember(member.userId, profiles, currentUserId);
                },
              ),
            if (!isMemberOwner)
              ListTile(
                leading: const Icon(Icons.person_remove, color: Colors.red),
                title: const Text('Remover da Liga'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmRemoveMember(member.userId, profiles, currentUserId);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges) {
      final shouldDiscard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Descartar alteracoes?'),
          content: const Text(
            'Voce tem alteracoes nao salvas. Deseja descarta-las?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Continuar Editando'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Descartar'),
            ),
          ],
        ),
      );
      return shouldDiscard ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final leagueAsync = ref.watch(leagueStreamProvider(widget.leagueId));
    final profiles = ref.watch(_settingsUserProfilesCacheProvider(widget.leagueId));
    final currentUser = ref.watch(currentUserProvider);
    final currentUserId = currentUser?.uid ?? '';

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configuracoes da Liga'),
          actions: [
            if (_hasUnsavedChanges)
              TextButton(
                onPressed: () => _saveChanges(currentUserId),
                child: const Text('Salvar'),
              ),
          ],
        ),
        body: Stack(
          children: [
            leagueAsync.when(
              data: (league) {
                if (league == null) {
                  return _buildNotFound(context);
                }

                final isAdmin = league.isAdmin(currentUserId);
                final isOwner = league.isOwner(currentUserId);

                if (!isAdmin) {
                  return _buildNoPermission(context);
                }

                // Initialize form with league data
                _initializeFormWithLeague(league);

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(leagueStreamProvider(widget.leagueId));
                    ref.invalidate(
                        _loadSettingsUserProfilesProvider(widget.leagueId));
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: AppSpacing.screenPadding,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Basic Info Section
                          _buildBasicInfoSection(context),
                          AppSpacing.gapVerticalLg,

                          // Invite Code Section
                          _buildInviteCodeSection(
                              context, league, isOwner, currentUserId),
                          AppSpacing.gapVerticalLg,

                          // Settings Section
                          _buildSettingsSection(context),
                          AppSpacing.gapVerticalLg,

                          // Members Section
                          _buildMembersSection(
                            context,
                            league,
                            currentUserId,
                            isOwner,
                            profiles,
                          ),
                          AppSpacing.gapVerticalXl,

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _hasUnsavedChanges
                                  ? () => _saveChanges(currentUserId)
                                  : null,
                              child: const Text('Salvar Alteracoes'),
                            ),
                          ),
                          AppSpacing.gapVerticalMd,
                        ],
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _buildError(context, error.toString()),
            ),
            // Loading overlay for actions
            if (_isPerformingAction)
              Container(
                color: Colors.black45,
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: AppSpacing.paddingLg,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          if (_actionMessage != null) ...[
                            AppSpacing.gapVerticalMd,
                            Text(_actionMessage!),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            AppSpacing.gapVerticalMd,
            Text(
              'Liga nao encontrada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppSpacing.gapVerticalSm,
            Text(
              'A liga pode ter sido excluida ou voce nao tem acesso.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVerticalLg,
            FilledButton(
              onPressed: () => context.pop(),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoPermission(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            AppSpacing.gapVerticalMd,
            Text(
              'Sem permissao',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppSpacing.gapVerticalSm,
            Text(
              'Apenas administradores podem acessar as configuracoes da liga.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVerticalLg,
            FilledButton(
              onPressed: () => context.pop(),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            AppSpacing.gapVerticalMd,
            Text(
              'Erro ao carregar configuracoes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppSpacing.gapVerticalSm,
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVerticalLg,
            FilledButton(
              onPressed: () {
                ref.invalidate(leagueStreamProvider(widget.leagueId));
              },
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                AppSpacing.gapHorizontalSm,
                Text(
                  'Informacoes Basicas',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            AppSpacing.gapVerticalMd,
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome da Liga',
                hintText: 'Digite o nome da liga',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'O nome da liga e obrigatorio';
                }
                if (value.trim().length < 3) {
                  return 'O nome deve ter pelo menos 3 caracteres';
                }
                return null;
              },
              onChanged: (_) => _markAsChanged(),
            ),
            AppSpacing.gapVerticalMd,
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descricao',
                hintText: 'Digite uma descricao (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (_) => _markAsChanged(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteCodeSection(
    BuildContext context,
    LeagueEntity league,
    bool isOwner,
    String currentUserId,
  ) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.vpn_key,
                  color: Theme.of(context).colorScheme.primary,
                ),
                AppSpacing.gapHorizontalSm,
                Text(
                  'Codigo de Convite',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            AppSpacing.gapVerticalMd,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      league.inviteCode,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontFamily: 'monospace',
                            letterSpacing: 4,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copiar',
                    onPressed: () => _copyInviteCode(league.inviteCode),
                  ),
                ],
              ),
            ),
            if (isOwner) ...[
              AppSpacing.gapVerticalMd,
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmRegenerateCode(currentUserId),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Gerar Novo Codigo'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune,
                  color: Theme.of(context).colorScheme.primary,
                ),
                AppSpacing.gapHorizontalSm,
                Text(
                  'Configuracoes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            AppSpacing.gapVerticalSm,
            SwitchListTile(
              title: const Text('Liga Publica'),
              subtitle: const Text('Visivel para todos os usuarios'),
              value: _isPublic,
              onChanged: (value) {
                setState(() => _isPublic = value);
                _markAsChanged();
              },
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              title: const Text('Maximo de Membros'),
              trailing: DropdownButton<int>(
                value: _maxMembers,
                items: [10, 25, 50, 100, 200]
                    .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                    .toList(),
                onChanged: (value) {
                  setState(() => _maxMembers = value ?? _maxMembers);
                  _markAsChanged();
                },
              ),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              title: const Text('Pontos por Check-in'),
              trailing: DropdownButton<int>(
                value: _pointsPerCheckIn,
                items: [5, 10, 15, 20, 25, 50]
                    .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                    .toList(),
                onChanged: (value) {
                  setState(() => _pointsPerCheckIn = value ?? _pointsPerCheckIn);
                  _markAsChanged();
                },
              ),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              title: const Text('Pontos por Review'),
              trailing: DropdownButton<int>(
                value: _pointsPerReview,
                items: [0, 2, 5, 10, 15, 20]
                    .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                    .toList(),
                onChanged: (value) {
                  setState(() => _pointsPerReview = value ?? _pointsPerReview);
                  _markAsChanged();
                },
              ),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Membros podem convidar'),
              subtitle: const Text('Permite que membros compartilhem o convite'),
              value: _allowMemberInvites,
              onChanged: (value) {
                setState(() => _allowMemberInvites = value);
                _markAsChanged();
              },
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              title: const Text('Requer aprovacao'),
              subtitle: const Text('Novos membros precisam de aprovacao'),
              value: _requireApproval,
              onChanged: (value) {
                setState(() => _requireApproval = value);
                _markAsChanged();
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersSection(
    BuildContext context,
    LeagueEntity league,
    String currentUserId,
    bool isOwner,
    Map<String, UserEntity?> profiles,
  ) {
    // Sort members: owner first, then admins, then regular members
    final sortedMembers = List<LeagueMember>.from(league.members)
      ..sort((a, b) {
        if (a.isOwner) return -1;
        if (b.isOwner) return 1;
        if (a.isAdmin && !b.isAdmin) return -1;
        if (!a.isAdmin && b.isAdmin) return 1;
        return 0;
      });

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.people,
                  color: Theme.of(context).colorScheme.primary,
                ),
                AppSpacing.gapHorizontalSm,
                Text(
                  'Membros (${league.memberCount})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            AppSpacing.gapVerticalMd,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedMembers.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final member = sortedMembers[index];
                final displayName =
                    _getMemberDisplayName(member.userId, profiles);
                final photoUrl = _getMemberPhotoUrl(member.userId, profiles);
                final isCurrentUser = member.userId == currentUserId;
                final canManage = isOwner && !member.isOwner && !isCurrentUser;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage:
                        photoUrl != null ? NetworkImage(photoUrl) : null,
                    child: photoUrl == null
                        ? Text(displayName.substring(0, 1).toUpperCase())
                        : null,
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayName + (isCurrentUser ? ' (voce)' : ''),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        _getRoleIcon(member.role),
                        size: 14,
                        color: _getRoleColor(member.role, context),
                      ),
                      AppSpacing.gapHorizontalXs,
                      Text(
                        _getRoleLabel(member.role),
                        style: TextStyle(
                          color: _getRoleColor(member.role, context),
                        ),
                      ),
                      AppSpacing.gapHorizontalMd,
                      Text('${member.points} pts'),
                    ],
                  ),
                  trailing: canManage
                      ? IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => _showMemberActions(
                            context,
                            member,
                            league,
                            currentUserId,
                            profiles,
                          ),
                        )
                      : null,
                  onTap: canManage
                      ? () => _showMemberActions(
                            context,
                            member,
                            league,
                            currentUserId,
                            profiles,
                          )
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
