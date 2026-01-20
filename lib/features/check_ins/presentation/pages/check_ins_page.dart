import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/photo_gallery/photo_gallery.dart';
import '../../../leagues/domain/entities/league_entity.dart';
import '../../domain/entities/check_in_entity.dart';
import '../providers/check_in_history_provider.dart';
import '../widgets/check_in_card_widget.dart';

/// View mode for check-ins display.
enum CheckInsViewMode {
  list,
  gallery,
}

/// Check-ins listing page showing user's burger check-ins
class CheckInsPage extends ConsumerStatefulWidget {
  const CheckInsPage({super.key});

  @override
  ConsumerState<CheckInsPage> createState() => _CheckInsPageState();
}

class _CheckInsPageState extends ConsumerState<CheckInsPage> {
  CheckInsViewMode _viewMode = CheckInsViewMode.list;

  void _toggleViewMode() {
    setState(() {
      _viewMode = _viewMode == CheckInsViewMode.list
          ? CheckInsViewMode.gallery
          : CheckInsViewMode.list;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const _FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkInsAsync = ref.watch(checkInHistoryProvider);
    final filter = ref.watch(checkInHistoryFilterNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Check-ins'),
        actions: [
          // View mode toggle
          IconButton(
            icon: Icon(
              _viewMode == CheckInsViewMode.list
                  ? Icons.grid_view_outlined
                  : Icons.view_list_outlined,
            ),
            tooltip: _viewMode == CheckInsViewMode.list
                ? 'Ver como galeria'
                : 'Ver como lista',
            onPressed: _toggleViewMode,
          ),
          if (filter.hasActiveFilters)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              tooltip: 'Limpar filtros',
              onPressed: () {
                ref.read(checkInHistoryFilterNotifierProvider.notifier).clearAllFilters();
              },
            ),
          IconButton(
            icon: Badge(
              isLabelVisible: filter.hasActiveFilters,
              child: const Icon(Icons.filter_alt_outlined),
            ),
            tooltip: 'Filtrar',
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: checkInsAsync.when(
        data: (checkIns) => _viewMode == CheckInsViewMode.list
            ? _CheckInsListView(
                checkIns: checkIns,
                filter: filter,
                onRefresh: () async {
                  ref.invalidate(checkInHistoryProvider);
                  await Future.delayed(const Duration(milliseconds: 500));
                },
              )
            : _CheckInsGalleryView(
                checkIns: checkIns,
                filter: filter,
                onRefresh: () async {
                  ref.invalidate(checkInHistoryProvider);
                  await Future.delayed(const Duration(milliseconds: 500));
                },
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => _ErrorView(
          error: error,
          onRetry: () => ref.invalidate(checkInHistoryProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createCheckIn),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// List view for displaying check-ins
class _CheckInsListView extends StatelessWidget {
  final List<CheckInEntity> checkIns;
  final CheckInHistoryFilter filter;
  final Future<void> Function() onRefresh;

  const _CheckInsListView({
    required this.checkIns,
    required this.filter,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (checkIns.isEmpty) {
      return _EmptyCheckInsView(hasFilters: filter.hasActiveFilters);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: checkIns.length,
        itemBuilder: (context, index) {
          final checkIn = checkIns[index];
          return CheckInCardWidget(
            checkIn: checkIn,
            onTap: () => context.push(
              AppRoutes.checkInDetails.replaceFirst(':checkInId', checkIn.id),
            ),
          );
        },
      ),
    );
  }
}

/// Gallery grid view for displaying check-ins as photos
class _CheckInsGalleryView extends StatelessWidget {
  final List<CheckInEntity> checkIns;
  final CheckInHistoryFilter filter;
  final Future<void> Function() onRefresh;

  const _CheckInsGalleryView({
    required this.checkIns,
    required this.filter,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (checkIns.isEmpty) {
      return _EmptyCheckInsView(hasFilters: filter.hasActiveFilters);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: PhotoGalleryGrid(
        checkIns: checkIns,
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        padding: const EdgeInsets.all(4),
        enableFullscreenPreview: true,
      ),
    );
  }
}

/// Empty state view when user has no check-ins
class _EmptyCheckInsView extends StatelessWidget {
  final bool hasFilters;

  const _EmptyCheckInsView({this.hasFilters = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.search_off : Icons.restaurant_outlined,
              size: 80,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              hasFilters
                  ? 'Nenhum check-in encontrado'
                  : 'Nenhum check-in ainda',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Tente ajustar os filtros para ver mais resultados.'
                  : 'Faca seu primeiro check-in clicando no botao +',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 24),
              Consumer(
                builder: (context, ref, _) => OutlinedButton.icon(
                  onPressed: () {
                    ref.read(checkInHistoryFilterNotifierProvider.notifier).clearAllFilters();
                  },
                  icon: const Icon(Icons.filter_alt_off),
                  label: const Text('Limpar filtros'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error view with retry option
class _ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar check-ins',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Verifique sua conexao e tente novamente.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Filter bottom sheet for selecting league and date range
class _FilterBottomSheet extends ConsumerStatefulWidget {
  const _FilterBottomSheet();

  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  String? _selectedLeagueId;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(checkInHistoryFilterNotifierProvider);
    _selectedLeagueId = filter.leagueId;
    _startDate = filter.startDate;
    _endDate = filter.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final leaguesAsync = ref.watch(userLeaguesForFilterProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Filtros',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedLeagueId = null;
                        _startDate = null;
                        _endDate = null;
                      });
                    },
                    child: const Text('Limpar'),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // League filter section
                    Text(
                      'Liga',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    leaguesAsync.when(
                      data: (leagues) => _LeagueFilterSection(
                        leagues: leagues,
                        selectedLeagueId: _selectedLeagueId,
                        onLeagueSelected: (leagueId) {
                          setState(() => _selectedLeagueId = leagueId);
                        },
                      ),
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (_, _) => Text(
                        'Erro ao carregar ligas',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Date range filter section
                    Text(
                      'Periodo',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DateRangeFilterSection(
                      startDate: _startDate,
                      endDate: _endDate,
                      onStartDateChanged: (date) {
                        setState(() => _startDate = date);
                      },
                      onEndDateChanged: (date) {
                        setState(() => _endDate = date);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Apply button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final notifier = ref.read(checkInHistoryFilterNotifierProvider.notifier);

                    // Apply filters
                    notifier.setLeagueFilter(_selectedLeagueId);
                    notifier.setDateRange(_startDate, _endDate);

                    Navigator.of(context).pop();
                  },
                  child: const Text('Aplicar filtros'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// League filter section with selectable chips
class _LeagueFilterSection extends StatelessWidget {
  final List<LeagueEntity> leagues;
  final String? selectedLeagueId;
  final void Function(String?) onLeagueSelected;

  const _LeagueFilterSection({
    required this.leagues,
    required this.selectedLeagueId,
    required this.onLeagueSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (leagues.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Voce ainda nao faz parte de nenhuma liga.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // "All leagues" chip
        ChoiceChip(
          label: const Text('Todas as ligas'),
          selected: selectedLeagueId == null,
          onSelected: (_) => onLeagueSelected(null),
        ),
        // League chips
        ...leagues.map((league) {
          final isSelected = league.id == selectedLeagueId;
          return ChoiceChip(
            avatar: isSelected
                ? null
                : CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      league.name.isNotEmpty ? league.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 12,
                      ),
                    ),
                  ),
            label: Text(league.name),
            selected: isSelected,
            onSelected: (_) {
              onLeagueSelected(isSelected ? null : league.id);
            },
          );
        }),
      ],
    );
  }
}

/// Date range filter section with date pickers
class _DateRangeFilterSection extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime?) onStartDateChanged;
  final void Function(DateTime?) onEndDateChanged;

  const _DateRangeFilterSection({
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Quick date range chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              label: const Text('Hoje'),
              onPressed: () {
                final today = DateTime.now();
                onStartDateChanged(today);
                onEndDateChanged(today);
              },
            ),
            ActionChip(
              label: const Text('Esta semana'),
              onPressed: () {
                final now = DateTime.now();
                final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
                onStartDateChanged(startOfWeek);
                onEndDateChanged(now);
              },
            ),
            ActionChip(
              label: const Text('Este mes'),
              onPressed: () {
                final now = DateTime.now();
                final startOfMonth = DateTime(now.year, now.month, 1);
                onStartDateChanged(startOfMonth);
                onEndDateChanged(now);
              },
            ),
            ActionChip(
              label: const Text('Ultimos 30 dias'),
              onPressed: () {
                final now = DateTime.now();
                final thirtyDaysAgo = now.subtract(const Duration(days: 30));
                onStartDateChanged(thirtyDaysAgo);
                onEndDateChanged(now);
              },
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Custom date range
        Row(
          children: [
            Expanded(
              child: _DatePickerField(
                label: 'Data inicial',
                date: startDate,
                onDateSelected: onStartDateChanged,
                lastDate: endDate ?? DateTime.now(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.arrow_forward,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: _DatePickerField(
                label: 'Data final',
                date: endDate,
                onDateSelected: onEndDateChanged,
                firstDate: startDate,
                lastDate: DateTime.now(),
              ),
            ),
          ],
        ),

        // Clear date range
        if (startDate != null || endDate != null) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              onStartDateChanged(null);
              onEndDateChanged(null);
            },
            icon: const Icon(Icons.clear),
            label: const Text('Limpar periodo'),
          ),
        ],
      ],
    );
  }
}

/// Date picker field widget
class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final void Function(DateTime?) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(2020),
          lastDate: lastDate ?? DateTime.now(),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                date != null
                    ? _formatDate(date!)
                    : label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: date != null
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (date != null)
              GestureDetector(
                onTap: () => onDateSelected(null),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
