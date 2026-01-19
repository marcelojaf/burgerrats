import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';

/// Leagues listing page
class LeaguesPage extends StatelessWidget {
  const LeaguesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ligas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: 'Entrar em uma liga',
            onPressed: () => context.push(AppRoutes.joinLeague),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text('${index + 1}'),
              ),
              title: Text('Liga ${index + 1}'),
              subtitle: Text('${10 - index} membros'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(
                AppRoutes.leagueDetails.replaceFirst(':leagueId', '${index + 1}'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createLeague),
        icon: const Icon(Icons.add),
        label: const Text('Nova Liga'),
      ),
    );
  }
}
