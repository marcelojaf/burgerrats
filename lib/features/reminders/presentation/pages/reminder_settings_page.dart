import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../leagues/domain/entities/league_entity.dart';
import '../../../leagues/presentation/providers/leaderboard_provider.dart';
import '../providers/reminder_settings_provider.dart';

/// Page for configuring reminder settings for a specific league
class ReminderSettingsPage extends ConsumerStatefulWidget {
  const ReminderSettingsPage({
    super.key,
    required this.league,
  });

  final LeagueEntity league;

  @override
  ConsumerState<ReminderSettingsPage> createState() =>
      _ReminderSettingsPageState();
}

class _ReminderSettingsPageState extends ConsumerState<ReminderSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(
      leagueReminderSettingsNotifierProvider((
        leagueId: widget.league.id,
        leagueName: widget.league.name,
      )),
    );

    // Listen for errors
    ref.listen(
      leagueReminderSettingsNotifierProvider((
        leagueId: widget.league.id,
        leagueName: widget.league.name,
      )),
      (previous, next) {
        if (next.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          ref
              .read(leagueReminderSettingsNotifierProvider((
                leagueId: widget.league.id,
                leagueName: widget.league.name,
              )).notifier)
              .clearError();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lembretes'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeagueHeader(context),
            const SizedBox(height: 24),
            _buildReminderToggle(context, settingsState),
            const SizedBox(height: 16),
            if (settingsState.settings.isEnabled) ...[
              _buildTimeSelector(context, settingsState),
              const SizedBox(height: 24),
              _buildInfoCard(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLeagueHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.emoji_events,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.league.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.league.memberCount} membros',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderToggle(
      BuildContext context, ReminderSettingsState settingsState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: settingsState.settings.isEnabled
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications_active,
                color: settingsState.settings.isEnabled
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lembrete diario',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    settingsState.settings.isEnabled
                        ? 'Voce sera lembrado de fazer check-in'
                        : 'Ative para receber lembretes',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            if (settingsState.isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Switch.adaptive(
                value: settingsState.settings.isEnabled,
                onChanged: (_) {
                  ref
                      .read(leagueReminderSettingsNotifierProvider((
                        leagueId: widget.league.id,
                        leagueName: widget.league.name,
                      )).notifier)
                      .toggleEnabled();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(
      BuildContext context, ReminderSettingsState settingsState) {
    return Card(
      child: InkWell(
        onTap: settingsState.isLoading ? null : () => _showTimePicker(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.access_time,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Horario do lembrete',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toque para alterar',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  settingsState.settings.formattedTime,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Voce recebera uma notificacao diaria no horario configurado lembrando de fazer check-in nesta liga.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final settingsState = ref.read(
      leagueReminderSettingsNotifierProvider((
        leagueId: widget.league.id,
        leagueName: widget.league.name,
      )),
    );

    final initialTime = TimeOfDay(
      hour: settingsState.settings.reminderHour,
      minute: settingsState.settings.reminderMinute,
    );

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (selectedTime != null && mounted) {
      ref
          .read(leagueReminderSettingsNotifierProvider((
            leagueId: widget.league.id,
            leagueName: widget.league.name,
          )).notifier)
          .updateTime(selectedTime);
    }
  }
}

/// Wrapper page that fetches the league by ID
/// Used for route navigation
class ReminderSettingsPageWrapper extends ConsumerWidget {
  const ReminderSettingsPageWrapper({
    super.key,
    required this.leagueId,
  });

  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagueAsync = ref.watch(leagueStreamProvider(leagueId));

    return leagueAsync.when(
      data: (league) {
        if (league == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Lembretes')),
            body: const Center(
              child: Text('Liga nao encontrada'),
            ),
          );
        }
        return ReminderSettingsPage(league: league);
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Lembretes')),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Lembretes')),
        body: Center(
          child: Text('Erro: $error'),
        ),
      ),
    );
  }
}

/// Widget for displaying reminder settings as a list tile
/// Can be used in league details or settings screens
class ReminderSettingsListTile extends ConsumerWidget {
  const ReminderSettingsListTile({
    super.key,
    required this.league,
    this.onTap,
  });

  final LeagueEntity league;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(
      leagueReminderSettingsProvider(league.id),
    );

    return settingsAsync.when(
      data: (settings) {
        return ListTile(
          leading: Icon(
            settings.isEnabled
                ? Icons.notifications_active
                : Icons.notifications_off,
            color: settings.isEnabled
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          title: const Text('Lembrete diario'),
          subtitle: Text(
            settings.isEnabled
                ? 'Ativado - ${settings.formattedTime}'
                : 'Desativado',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        );
      },
      loading: () => const ListTile(
        leading: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        title: Text('Lembrete diario'),
        subtitle: Text('Carregando...'),
      ),
      error: (_, _) => ListTile(
        leading: Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
        ),
        title: const Text('Lembrete diario'),
        subtitle: const Text('Erro ao carregar'),
        onTap: onTap,
      ),
    );
  }
}
