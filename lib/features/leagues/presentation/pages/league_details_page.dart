import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/deep_link_service.dart';

/// League details page showing league information
class LeagueDetailsPage extends StatelessWidget {
  const LeagueDetailsPage({
    super.key,
    required this.leagueId,
  });

  final String leagueId;

  void _shareLeagueInvite(BuildContext context) {
    final deepLinkService = getIt<DeepLinkService>();
    final link = deepLinkService.generateLeagueInviteLink(leagueId);

    Share.share(
      'Join my burger league on BurgerRats! $link',
      subject: 'League Invitation',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('League $leagueId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share League Invite',
            onPressed: () => _shareLeagueInvite(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'League $leagueId',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A competitive burger rating league',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(Icons.people, size: 20),
                        SizedBox(width: 8),
                        Text('10 members'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Leaderboard',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...List.generate(5, (index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text('Player ${index + 1}'),
                trailing: Text('${100 - index * 10} pts'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
