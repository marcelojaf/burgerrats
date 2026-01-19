import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/deep_link_service.dart';

/// Check-in details page showing a specific burger check-in
class CheckInDetailsPage extends StatelessWidget {
  const CheckInDetailsPage({
    super.key,
    required this.checkInId,
  });

  final String checkInId;

  void _shareCheckIn(BuildContext context) {
    final deepLinkService = getIt<DeepLinkService>();
    final link = deepLinkService.generateCheckInShareLink(checkInId);

    Share.share(
      'Check out this burger I found on BurgerRats! $link',
      subject: 'Burger Check-in',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share Check-in',
            onPressed: () => _shareCheckIn(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.restaurant, size: 64),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Burger Joint $checkInId',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ...List.generate(
                  5,
                  (i) => Icon(
                    i < 4 ? Icons.star : Icons.star_border,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '4.0',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Amazing burger! The patty was juicy and perfectly seasoned. '
                      'The bun was fresh and the toppings were generous. '
                      'Would definitely come back!',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const ListTile(
                      dense: true,
                      leading: Icon(Icons.location_on),
                      title: Text('123 Burger Street'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const ListTile(
                      dense: true,
                      leading: Icon(Icons.calendar_today),
                      title: Text('January 15, 2026'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const ListTile(
                      dense: true,
                      leading: Icon(Icons.attach_money),
                      title: Text('\$15.99'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
