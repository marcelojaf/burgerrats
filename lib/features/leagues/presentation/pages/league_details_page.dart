import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/deep_link_service.dart';
import '../../../../core/state/providers/auth_state_provider.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/user_repository.dart';
import '../../domain/entities/league_entity.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../../domain/repositories/league_repository.dart';
import '../providers/leaderboard_provider.dart';

/// Provider for user profiles cache
final _userProfilesCacheProvider = StateProvider.family<Map<String, UserEntity?>, String>(
  (ref, leagueId) => {},
);

/// Provider to load user profiles for a league
final _loadUserProfilesProvider = FutureProvider.family<void, String>((ref, leagueId) async {
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

  ref.read(_userProfilesCacheProvider(leagueId).notifier).state = profiles;
});

/// League details page showing comprehensive league information
class LeagueDetailsPage extends ConsumerStatefulWidget {
  const LeagueDetailsPage({
    super.key,
    required this.leagueId,
  });

  final String leagueId;

  @override
  ConsumerState<LeagueDetailsPage> createState() => _LeagueDetailsPageState();
}

class _LeagueDetailsPageState extends ConsumerState<LeagueDetailsPage> {
  bool _isPerformingAction = false;
  String? _actionMessage;

  @override
  void initState() {
    super.initState();
    // Trigger profile loading
    Future.microtask(() {
      ref.read(_loadUserProfilesProvider(widget.leagueId));
    });
  }

  void _shareLeagueInvite(LeagueEntity league) {
    final l10n = context.l10n;
    final deepLinkService = getIt<DeepLinkService>();
    final link = deepLinkService.generateLeagueInviteLink(league.id);

    Share.share(
      l10n.shareLeagueInviteMessage(league.name, link, league.inviteCode),
      subject: l10n.leagueInviteSubject(league.name),
    );
  }

  void _copyInviteCode(String inviteCode) {
    final l10n = context.l10n;
    Clipboard.setData(ClipboardData(text: inviteCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.codeCopied),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getMemberDisplayName(String userId, Map<String, UserEntity?> profiles) {
    final profile = profiles[userId];
    if (profile != null) {
      return profile.displayNameOrEmail;
    }
    return userId.length > 8 ? '${userId.substring(0, 8)}...' : userId;
  }

  String? _getMemberPhotoUrl(String userId, Map<String, UserEntity?> profiles) {
    return profiles[userId]?.photoURL;
  }

  void _showMemberActions(
    BuildContext context,
    LeagueMember member,
    LeagueEntity league,
    String currentUserId,
    Map<String, UserEntity?> profiles,
  ) {
    final l10n = context.l10n;
    final isCurrentUserAdmin = league.isAdmin(currentUserId);
    final isCurrentUserOwner = league.isOwner(currentUserId);
    final isMemberOwner = member.isOwner;
    final isMemberAdmin = member.isAdmin;
    final isCurrentUser = member.userId == currentUserId;

    // Can't perform actions on yourself (except leave) or on owner
    if (isCurrentUser || isMemberOwner) return;

    // Only admins/owners can manage members
    if (!isCurrentUserAdmin) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(_getMemberDisplayName(member.userId, profiles)),
              subtitle: Text(_getRoleLabel(context, member.role)),
            ),
            const Divider(),
            if (isCurrentUserOwner && !isMemberAdmin)
              ListTile(
                leading: const Icon(Icons.arrow_upward, color: Colors.green),
                title: Text(l10n.promoteToAdmin),
                onTap: () {
                  Navigator.pop(context);
                  _confirmPromote(member.userId, profiles, currentUserId);
                },
              ),
            if (isCurrentUserOwner && isMemberAdmin && !isMemberOwner)
              ListTile(
                leading: const Icon(Icons.arrow_downward, color: Colors.orange),
                title: Text(l10n.removeAdmin),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDemote(member.userId, profiles, currentUserId);
                },
              ),
            if (isCurrentUserAdmin && !isMemberOwner)
              ListTile(
                leading: const Icon(Icons.person_remove, color: Colors.red),
                title: Text(l10n.removeFromLeague),
                onTap: () {
                  Navigator.pop(context);
                  _confirmRemove(member.userId, profiles, currentUserId);
                },
              ),
            if (isCurrentUserOwner && !isMemberOwner)
              ListTile(
                leading: const Icon(Icons.swap_horiz, color: Colors.blue),
                title: Text(l10n.transferOwnership),
                onTap: () {
                  Navigator.pop(context);
                  _confirmTransferOwnership(member.userId, _getMemberDisplayName(member.userId, profiles), currentUserId);
                },
              ),
          ],
        ),
      ),
    );
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
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorMessage(e.toString())),
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

  void _confirmPromote(String userId, Map<String, UserEntity?> profiles, String currentUserId) {
    final l10n = context.l10n;
    final displayName = _getMemberDisplayName(userId, profiles);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.promoteToAdmin),
        content: Text(l10n.promoteToAdminConfirmation(displayName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _performAction(l10n.promotingMember, () async {
                final repository = getIt<LeagueRepository>();
                await repository.updateMemberRole(
                  leagueId: widget.leagueId,
                  userId: userId,
                  newRole: LeagueMemberRole.admin,
                  requesterId: currentUserId,
                );
              });
            },
            child: Text(l10n.promote),
          ),
        ],
      ),
    );
  }

  void _confirmDemote(String userId, Map<String, UserEntity?> profiles, String currentUserId) {
    final l10n = context.l10n;
    final displayName = _getMemberDisplayName(userId, profiles);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.removeAdmin),
        content: Text(l10n.removeAdminConfirmation(displayName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _performAction(l10n.removingAdmin, () async {
                final repository = getIt<LeagueRepository>();
                await repository.updateMemberRole(
                  leagueId: widget.leagueId,
                  userId: userId,
                  newRole: LeagueMemberRole.member,
                  requesterId: currentUserId,
                );
              });
            },
            child: Text(l10n.removeAdmin),
          ),
        ],
      ),
    );
  }

  void _confirmRemove(String userId, Map<String, UserEntity?> profiles, String currentUserId) {
    final l10n = context.l10n;
    final displayName = _getMemberDisplayName(userId, profiles);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.removeMember),
        content: Text(l10n.removeMemberConfirmation(displayName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(context);
              _performAction(l10n.removingMember, () async {
                final repository = getIt<LeagueRepository>();
                await repository.removeMember(
                  leagueId: widget.leagueId,
                  userId: userId,
                  requesterId: currentUserId,
                );
              });
            },
            child: Text(l10n.remove),
          ),
        ],
      ),
    );
  }

  void _confirmLeaveLeague(String userId, bool isOwner, LeagueEntity league, Map<String, UserEntity?> profiles) {
    if (isOwner) {
      // Check if there are other members to transfer ownership to
      final otherMembers = league.members.where((m) => m.userId != userId).toList();
      if (otherMembers.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Nao e possivel sair'),
            content: const Text(
              'Voce e o unico membro da liga. Para sair, voce precisa excluir a liga.',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendi'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Nao e possivel sair'),
            content: const Text(
              'Voce e o dono da liga. Para sair, voce precisa excluir a liga ou transferir a propriedade para outro membro.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showTransferOwnershipDialog(league, userId, profiles);
                },
                child: const Text('Transferir Propriedade'),
              ),
            ],
          ),
        );
      }
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Liga'),
        content: const Text(
          'Deseja sair desta liga? Seus pontos serao perdidos e esta acao nao pode ser desfeita.',
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
            onPressed: () async {
              final navigator = Navigator.of(context);
              navigator.pop();
              await _performAction('Saindo da liga...', () async {
                final repository = getIt<LeagueRepository>();
                await repository.removeMember(
                  leagueId: widget.leagueId,
                  userId: userId,
                  requesterId: userId,
                );
              });
              if (mounted) {
                navigator.pop();
              }
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _showTransferOwnershipDialog(LeagueEntity league, String currentUserId, Map<String, UserEntity?> profiles) {
    final otherMembers = league.members.where((m) => m.userId != currentUserId).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transferir Propriedade'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selecione o novo dono da liga:'),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: SingleChildScrollView(
                child: Column(
                  children: otherMembers.map((member) {
                    final displayName = _getMemberDisplayName(member.userId, profiles);
                    final photoUrl = _getMemberPhotoUrl(member.userId, profiles);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                        child: photoUrl == null ? Text(displayName.substring(0, 1).toUpperCase()) : null,
                      ),
                      title: Text(displayName),
                      subtitle: Text(_getRoleLabel(context, member.role)),
                      onTap: () {
                        Navigator.pop(context);
                        _confirmTransferOwnership(member.userId, displayName, currentUserId);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _confirmTransferOwnership(String newOwnerId, String newOwnerName, String currentUserId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Transferencia'),
        content: Text(
          'Deseja transferir a propriedade da liga para $newOwnerName?\n\nVoce se tornara um admin da liga.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _performAction('Transferindo propriedade...', () async {
                final repository = getIt<LeagueRepository>();
                await repository.transferOwnership(
                  leagueId: widget.leagueId,
                  newOwnerId: newOwnerId,
                  requesterId: currentUserId,
                );
              });
            },
            child: const Text('Transferir'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(LeagueEntity league, String currentUserId) {
    // Create mutable copies of settings values
    bool isPublic = league.settings.isPublic;
    int maxMembers = league.settings.maxMembers;
    int pointsPerCheckIn = league.settings.pointsPerCheckIn;
    int pointsPerReview = league.settings.pointsPerReview;
    bool allowMemberInvites = league.settings.allowMemberInvites;
    bool requireApproval = league.settings.requireApproval;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Configuracoes da Liga'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Liga Publica'),
                  subtitle: const Text('Visivel para todos os usuarios'),
                  value: isPublic,
                  onChanged: (value) => setState(() => isPublic = value),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Maximo de Membros'),
                  trailing: DropdownButton<int>(
                    value: maxMembers,
                    items: [10, 25, 50, 100, 200]
                        .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                        .toList(),
                    onChanged: (value) => setState(() => maxMembers = value ?? maxMembers),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Pontos por Check-in'),
                  trailing: DropdownButton<int>(
                    value: pointsPerCheckIn,
                    items: [5, 10, 15, 20, 25, 50]
                        .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                        .toList(),
                    onChanged: (value) => setState(() => pointsPerCheckIn = value ?? pointsPerCheckIn),
                  ),
                ),
                ListTile(
                  title: const Text('Pontos por Review'),
                  trailing: DropdownButton<int>(
                    value: pointsPerReview,
                    items: [0, 2, 5, 10, 15, 20]
                        .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                        .toList(),
                    onChanged: (value) => setState(() => pointsPerReview = value ?? pointsPerReview),
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Membros podem convidar'),
                  subtitle: const Text('Permite que membros compartilhem o convite'),
                  value: allowMemberInvites,
                  onChanged: (value) => setState(() => allowMemberInvites = value),
                ),
                SwitchListTile(
                  title: const Text('Requer aprovacao'),
                  subtitle: const Text('Novos membros precisam de aprovacao'),
                  value: requireApproval,
                  onChanged: (value) => setState(() => requireApproval = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _performAction('Salvando configuracoes...', () async {
                  final newSettings = LeagueSettings(
                    isPublic: isPublic,
                    maxMembers: maxMembers,
                    pointsPerCheckIn: pointsPerCheckIn,
                    pointsPerReview: pointsPerReview,
                    allowMemberInvites: allowMemberInvites,
                    requireApproval: requireApproval,
                  );
                  final repository = getIt<LeagueRepository>();
                  await repository.updateLeagueSettings(
                    leagueId: widget.leagueId,
                    settings: newSettings,
                    requesterId: currentUserId,
                  );
                });
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteLeague() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Liga'),
        content: const Text(
          'Deseja excluir esta liga permanentemente? Todos os membros serao removidos e esta acao nao pode ser desfeita.',
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
            onPressed: () async {
              final navigator = Navigator.of(context);
              navigator.pop();
              await _performAction('Excluindo liga...', () async {
                final repository = getIt<LeagueRepository>();
                await repository.deleteLeague(widget.leagueId);
              });
              if (mounted) {
                navigator.pop();
              }
            },
            child: const Text('Excluir'),
          ),
        ],
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

  String _getRoleLabel(BuildContext context, LeagueMemberRole role) {
    final l10n = context.l10n;
    return switch (role) {
      LeagueMemberRole.owner => l10n.roleOwner,
      LeagueMemberRole.admin => l10n.roleAdmin,
      LeagueMemberRole.member => l10n.roleMember,
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
      LeagueMemberRole.member => Theme.of(context).colorScheme.onSurfaceVariant,
    };
  }

  Color _getMedalColor(int rank) {
    return switch (rank) {
      1 => Colors.amber,
      2 => Colors.grey.shade400,
      3 => Colors.brown.shade400,
      _ => Colors.transparent,
    };
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final leagueAsync = ref.watch(leagueStreamProvider(widget.leagueId));
    final leaderboardAsync = ref.watch(leagueLeaderboardStreamProvider(widget.leagueId));
    final profiles = ref.watch(_userProfilesCacheProvider(widget.leagueId));
    final currentUser = ref.watch(currentUserProvider);
    final currentUserId = currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: leagueAsync.when(
          data: (league) => Text(league?.name ?? 'Detalhes da Liga'),
          loading: () => const Text('Carregando...'),
          error: (_, _) => const Text('Detalhes da Liga'),
        ),
        actions: [
          leagueAsync.when(
            data: (league) {
              if (league == null) return const SizedBox.shrink();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    tooltip: 'Compartilhar Convite',
                    onPressed: () => _shareLeagueInvite(league),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'leave':
                          _confirmLeaveLeague(
                            currentUserId,
                            league.isOwner(currentUserId),
                            league,
                            profiles,
                          );
                          break;
                        case 'delete':
                          _confirmDeleteLeague();
                          break;
                        case 'transfer':
                          _showTransferOwnershipDialog(league, currentUserId, profiles);
                          break;
                        case 'settings':
                          context.push('/leagues/${widget.leagueId}/settings');
                          break;
                        case 'reminders':
                          context.push('/leagues/${widget.leagueId}/reminders');
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      final isOwner = league.isOwner(currentUserId);
                      final isAdmin = league.isAdmin(currentUserId);
                      final hasOtherMembers = league.members.length > 1;
                      return [
                        if (isAdmin)
                          const PopupMenuItem(
                            value: 'settings',
                            child: Row(
                              children: [
                                Icon(Icons.settings),
                                SizedBox(width: 8),
                                Text('Configuracoes'),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'reminders',
                          child: Row(
                            children: [
                              Icon(Icons.notifications),
                              SizedBox(width: 8),
                              Text('Lembretes'),
                            ],
                          ),
                        ),
                        if (isOwner && hasOtherMembers)
                          const PopupMenuItem(
                            value: 'transfer',
                            child: Row(
                              children: [
                                Icon(Icons.swap_horiz),
                                SizedBox(width: 8),
                                Text('Transferir Propriedade'),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'leave',
                          child: Row(
                            children: [
                              Icon(Icons.exit_to_app),
                              SizedBox(width: 8),
                              Text('Sair da Liga'),
                            ],
                          ),
                        ),
                        if (isOwner)
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_forever,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Excluir Liga',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ];
                    },
                  ),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
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

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(leagueStreamProvider(widget.leagueId));
                  ref.invalidate(_loadUserProfilesProvider(widget.leagueId));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // League Info Card
                      _buildLeagueInfoCard(context, league),
                      const SizedBox(height: 16),

                      // Invite Code Card (for admins)
                      if (isAdmin) ...[
                        _buildInviteCodeCard(context, league, isOwner, currentUserId),
                        const SizedBox(height: 16),
                      ],

                      // Statistics Card
                      _buildStatisticsCard(context, league),
                      const SizedBox(height: 16),

                      // Settings Card
                      _buildSettingsCard(context, league),
                      const SizedBox(height: 24),

                      // Leaderboard Section
                      _buildLeaderboardSection(
                        context,
                        leaderboardAsync,
                        league,
                        currentUserId,
                        isAdmin,
                        profiles,
                      ),
                      const SizedBox(height: 24),
                    ],
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
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        if (_actionMessage != null) ...[
                          const SizedBox(height: 16),
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
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Liga nao encontrada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'A liga pode ter sido excluida ou voce nao tem acesso.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar liga',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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

  Widget _buildLeagueInfoCard(BuildContext context, LeagueEntity league) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    league.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                if (league.settings.isPublic)
                  Chip(
                    label: const Text('Publica'),
                    avatar: const Icon(Icons.public, size: 16),
                    visualDensity: VisualDensity.compact,
                  )
                else
                  Chip(
                    label: const Text('Privada'),
                    avatar: const Icon(Icons.lock, size: 16),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            if (league.description != null && league.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                league.description!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  '${league.memberCount}/${league.settings.maxMembers} membros',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Criada em ${_formatDate(league.createdAt)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteCodeCard(
    BuildContext context,
    LeagueEntity league,
    bool isOwner,
    String currentUserId,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.vpn_key,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Codigo de Convite',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
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
              const SizedBox(height: 12),
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

  Widget _buildStatisticsCard(BuildContext context, LeagueEntity league) {
    final totalPoints =
        league.members.fold<int>(0, (sum, m) => sum + m.points);
    final avgPoints =
        league.memberCount > 0 ? (totalPoints / league.memberCount).round() : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Estatisticas',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    Icons.emoji_events,
                    totalPoints.toString(),
                    'Total de Pontos',
                    Colors.amber,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    Icons.trending_up,
                    avgPoints.toString(),
                    'Media por Membro',
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    Icons.group,
                    league.memberCount.toString(),
                    'Membros',
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color iconColor,
  ) {
    return Column(
      children: [
        Icon(icon, size: 28, color: iconColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context, LeagueEntity league) {
    final settings = league.settings;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Configuracoes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSettingRow(
              context,
              Icons.restaurant,
              'Pontos por Check-in',
              '${settings.pointsPerCheckIn} pts',
            ),
            _buildSettingRow(
              context,
              Icons.rate_review,
              'Pontos por Review',
              '${settings.pointsPerReview} pts',
            ),
            _buildSettingRow(
              context,
              Icons.people_outline,
              'Maximo de Membros',
              '${settings.maxMembers}',
            ),
            _buildSettingRow(
              context,
              Icons.person_add,
              'Membros podem convidar',
              settings.allowMemberInvites ? 'Sim' : 'Nao',
            ),
            _buildSettingRow(
              context,
              Icons.verified_user,
              'Requer aprovacao',
              settings.requireApproval ? 'Sim' : 'Nao',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardSection(
    BuildContext context,
    AsyncValue<List<LeaderboardEntry>> leaderboardAsync,
    LeagueEntity league,
    String currentUserId,
    bool isAdmin,
    Map<String, UserEntity?> profiles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.leaderboard,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Ranking',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            leaderboardAsync.when(
              data: (entries) => Text(
                '${entries.length} membros',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        leaderboardAsync.when(
          data: (entries) {
            if (entries.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nenhum membro ainda',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Faca check-ins para ganhar pontos!',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: entries.map((entry) {
                final member = entry.member;
                final isCurrentUser = member.userId == currentUserId;
                final displayName = _getMemberDisplayName(member.userId, profiles);
                final photoUrl = _getMemberPhotoUrl(member.userId, profiles);
                final rank = entry.rank;

                return Card(
                  color: isCurrentUser
                      ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
                      : null,
                  child: ListTile(
                    onTap: isAdmin
                        ? () => _showMemberActions(
                              context,
                              member,
                              league,
                              currentUserId,
                              profiles,
                            )
                        : null,
                    leading: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              photoUrl != null ? NetworkImage(photoUrl) : null,
                          child: photoUrl == null
                              ? Text(displayName.substring(0, 1).toUpperCase())
                              : null,
                        ),
                        if (rank <= 3)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: _getMedalColor(rank),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                rank.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            displayName,
                            style: TextStyle(
                              fontWeight:
                                  isCurrentUser ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        Icon(
                          _getRoleIcon(member.role),
                          size: 16,
                          color: _getRoleColor(member.role, context),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(_getRoleLabel(context, member.role)),
                        if (entry.isTied) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Empatado',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${member.points} pts',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Carregando ranking...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          error: (error, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar ranking',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => ref.invalidate(
                      leagueLeaderboardStreamProvider(widget.leagueId),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
