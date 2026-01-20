import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/shareable_image_service.dart';
import '../../../../shared/widgets/photo_gallery/photo_gallery.dart';
import '../../../leagues/domain/repositories/league_repository.dart';
import '../../domain/entities/check_in_entity.dart';
import '../../domain/repositories/check_in_repository.dart';

/// Provider for watching a single check-in by ID
final checkInByIdProvider =
    StreamProvider.family<CheckInEntity?, String>((ref, checkInId) {
  final repository = getIt<CheckInRepository>();
  return repository.watchCheckIn(checkInId);
});

/// Check-in details page showing a specific burger check-in
class CheckInDetailsPage extends ConsumerWidget {
  const CheckInDetailsPage({
    super.key,
    required this.checkInId,
  });

  final String checkInId;

  Future<void> _shareCheckIn(BuildContext context, CheckInEntity? checkIn) async {
    if (checkIn == null) return;

    // Show loading indicator
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Gerando imagem compartilhavel...'),
        duration: Duration(seconds: 1),
      ),
    );

    // Get league name for branding
    final leagueRepository = getIt<LeagueRepository>();
    final league = await leagueRepository.getLeagueById(checkIn.leagueId);
    final leagueName = league?.name ?? 'Liga BurgerRats';

    // Share with branded image
    final shareService = getIt<ShareableImageService>();
    await shareService.shareCheckInWithBrandedImage(
      checkIn: checkIn,
      leagueName: leagueName,
    );
  }

  void _openFullscreenPhoto(BuildContext context, CheckInEntity checkIn) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => FullscreenPhotoViewer(
          checkIns: [checkIn],
          initialIndex: 0,
          showDetails: true,
          enableShare: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkInAsync = ref.watch(checkInByIdProvider(checkInId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Check-in'),
        actions: [
          checkInAsync.whenOrNull(
                data: (checkIn) => IconButton(
                  icon: const Icon(Icons.share),
                  tooltip: 'Compartilhar',
                  onPressed: () => _shareCheckIn(context, checkIn),
                ),
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: checkInAsync.when(
        data: (checkIn) {
          if (checkIn == null) {
            return const _NotFoundView();
          }
          return _CheckInDetailsContent(
            checkIn: checkIn,
            onPhotoTap: () => _openFullscreenPhoto(context, checkIn),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => _ErrorView(
          error: error,
          onRetry: () => ref.invalidate(checkInByIdProvider(checkInId)),
        ),
      ),
    );
  }
}

/// Content view for check-in details
class _CheckInDetailsContent extends StatelessWidget {
  const _CheckInDetailsContent({
    required this.checkIn,
    required this.onPhotoTap,
  });

  final CheckInEntity checkIn;
  final VoidCallback onPhotoTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo
          GestureDetector(
            onTap: onPhotoTap,
            child: Hero(
              tag: 'check_in_photo_${checkIn.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CachedPhotoWidget(
                    imageUrl: checkIn.photoURL,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Restaurant name
          if (checkIn.displayRestaurantName != null)
            Text(
              checkIn.displayRestaurantName!,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
          else
            Text(
              'Check-in',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

          const SizedBox(height: 8),

          // Rating
          if (checkIn.hasRating)
            Row(
              children: [
                ...List.generate(
                  5,
                  (i) => Icon(
                    i < checkIn.rating! ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: i < checkIn.rating!
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${checkIn.rating}.0',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 16),

          // Note card (if present)
          if (checkIn.hasNote)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notes,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Nota',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      checkIn.note!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

          if (checkIn.hasNote) const SizedBox(height: 16),

          // Details card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detalhes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Location
                  if (checkIn.hasLocation && checkIn.location!.hasAddress)
                    ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.location_on,
                        color: colorScheme.primary,
                      ),
                      title: Text(checkIn.location!.address!),
                      contentPadding: EdgeInsets.zero,
                    ),

                  // Date/time
                  ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.calendar_today,
                      color: colorScheme.primary,
                    ),
                    title: Text(_formatDateTime(checkIn.timestamp)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime timestamp) {
    final months = [
      'Janeiro',
      'Fevereiro',
      'Marco',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    final day = timestamp.day;
    final month = months[timestamp.month - 1];
    final year = timestamp.year;
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');

    return '$day de $month de $year as $hour:$minute';
  }
}

/// Not found view when check-in doesn't exist
class _NotFoundView extends StatelessWidget {
  const _NotFoundView();

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
              Icons.search_off,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Check-in nao encontrado',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Este check-in pode ter sido removido ou o link esta incorreto.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error view with retry option
class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

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
              'Erro ao carregar check-in',
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
