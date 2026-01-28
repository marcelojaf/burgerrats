import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../leagues/presentation/providers/my_leagues_provider.dart';
import '../../domain/entities/activity_feed_entry.dart';
import '../providers/activity_feed_provider.dart';
import '../widgets/feed_item_card.dart';

/// Activity Feed page showing recent check-ins from all user's leagues
class ActivityFeedPage extends ConsumerWidget {
  const ActivityFeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(activityFeedPaginationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BurgerRats'),
        centerTitle: true,
      ),
      body: _buildBody(context, ref, feedState),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ActivityFeedPaginationState state,
  ) {
    if (state.isLoading && state.entries.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.hasError && state.entries.isEmpty) {
      return _ErrorView(
        message: state.errorMessage ?? 'Erro desconhecido',
        onRetry: () =>
            ref.read(activityFeedPaginationProvider.notifier).refresh(),
      );
    }

    if (state.isEmpty) {
      final hasLeagues = ref.watch(hasLeaguesProvider);
      return _EmptyFeedView(
        hasLeagues: hasLeagues,
        onCreateCheckIn: () => context.push(AppRoutes.createCheckIn),
        onJoinLeague: () => context.push(AppRoutes.joinLeague),
      );
    }

    return _FeedListView(
      entries: state.entries,
      isLoadingMore: state.isLoadingMore,
      hasMore: state.hasMore,
      onRefresh: () =>
          ref.read(activityFeedPaginationProvider.notifier).refresh(),
      onLoadMore: () =>
          ref.read(activityFeedPaginationProvider.notifier).loadMore(),
    );
  }
}

/// List view with infinite scroll for activity feed
class _FeedListView extends StatefulWidget {
  final List<ActivityFeedEntry> entries;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onRefresh;
  final VoidCallback onLoadMore;

  const _FeedListView({
    required this.entries,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onRefresh,
    required this.onLoadMore,
  });

  @override
  State<_FeedListView> createState() => _FeedListViewState();
}

class _FeedListViewState extends State<_FeedListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh();
        // Wait a bit for the refresh to complete
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: widget.entries.length + (widget.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == widget.entries.length) {
            return const _LoadingMoreIndicator();
          }
          return FeedItemCard(entry: widget.entries[index]);
        },
      ),
    );
  }
}

/// Loading indicator shown when loading more items
class _LoadingMoreIndicator extends StatelessWidget {
  const _LoadingMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Empty state view when user has no feed entries
class _EmptyFeedView extends StatelessWidget {
  final bool hasLeagues;
  final VoidCallback onCreateCheckIn;
  final VoidCallback onJoinLeague;

  const _EmptyFeedView({
    required this.hasLeagues,
    required this.onCreateCheckIn,
    required this.onJoinLeague,
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
              Icons.restaurant_menu,
              size: 80,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhuma atividade ainda',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasLeagues
                  ? 'Faca check-ins de burgers para ver a atividade aqui!'
                  : 'Participe de uma liga e faca check-ins de burgers para ver a atividade aqui!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                FilledButton.icon(
                  onPressed: onCreateCheckIn,
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Fazer Check-in'),
                ),
                if (!hasLeagues) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: onJoinLeague,
                    icon: const Icon(Icons.login),
                    label: const Text('Entrar em uma Liga'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Error view with retry option
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
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
              'Erro ao carregar feed',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
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
