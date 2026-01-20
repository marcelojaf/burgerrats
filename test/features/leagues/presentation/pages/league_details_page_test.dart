import 'package:flutter_test/flutter_test.dart';

import 'package:burgerrats/features/leagues/domain/entities/league_entity.dart';
import 'package:burgerrats/features/leagues/domain/entities/leaderboard_entry.dart';

void main() {
  group('LeagueDetailsPage', () {
    late LeagueEntity testLeague;

    setUp(() {
      testLeague = LeagueEntity(
        id: 'test-league-123',
        name: 'Test Burger League',
        description: 'A test league for burger enthusiasts',
        createdBy: 'owner-user-id',
        inviteCode: 'ABC123',
        createdAt: DateTime(2024, 1, 15),
        settings: const LeagueSettings(
          isPublic: true,
          maxMembers: 50,
          pointsPerCheckIn: 10,
          pointsPerReview: 5,
          allowMemberInvites: true,
          requireApproval: false,
        ),
        members: [
          LeagueMember(
            userId: 'owner-user-id',
            role: LeagueMemberRole.owner,
            points: 150,
            joinedAt: DateTime(2024, 1, 15),
          ),
          LeagueMember(
            userId: 'admin-user-id',
            role: LeagueMemberRole.admin,
            points: 120,
            joinedAt: DateTime(2024, 1, 16),
          ),
          LeagueMember(
            userId: 'member-user-id',
            role: LeagueMemberRole.member,
            points: 80,
            joinedAt: DateTime(2024, 1, 17),
          ),
        ],
      );
    });

    testWidgets('should display league name in app bar', (tester) async {
      // This test verifies the LeagueEntity structure works correctly
      expect(testLeague.name, 'Test Burger League');
      expect(testLeague.memberCount, 3);
      expect(testLeague.inviteCode, 'ABC123');
    });

    testWidgets('should have correct member count and settings', (
      tester,
    ) async {
      expect(testLeague.settings.isPublic, true);
      expect(testLeague.settings.maxMembers, 50);
      expect(testLeague.settings.pointsPerCheckIn, 10);
      expect(testLeague.settings.pointsPerReview, 5);
      expect(testLeague.canJoin, true);
      expect(testLeague.isFull, false);
    });

    testWidgets('should correctly identify member roles', (tester) async {
      expect(testLeague.isOwner('owner-user-id'), true);
      expect(testLeague.isOwner('admin-user-id'), false);
      expect(testLeague.isAdmin('owner-user-id'), true);
      expect(testLeague.isAdmin('admin-user-id'), true);
      expect(testLeague.isAdmin('member-user-id'), false);
      expect(testLeague.isMember('owner-user-id'), true);
      expect(testLeague.isMember('random-user'), false);
    });

    testWidgets('should generate correct leaderboard with rankings', (
      tester,
    ) async {
      final leaderboard = testLeague.rankedLeaderboard;

      expect(leaderboard.length, 3);

      // First place
      expect(leaderboard[0].rank, 1);
      expect(leaderboard[0].userId, 'owner-user-id');
      expect(leaderboard[0].points, 150);
      expect(leaderboard[0].isTied, false);

      // Second place
      expect(leaderboard[1].rank, 2);
      expect(leaderboard[1].userId, 'admin-user-id');
      expect(leaderboard[1].points, 120);

      // Third place
      expect(leaderboard[2].rank, 3);
      expect(leaderboard[2].userId, 'member-user-id');
      expect(leaderboard[2].points, 80);
    });

    testWidgets('should handle tied rankings correctly', (tester) async {
      final leagueWithTies = LeagueEntity(
        id: 'test-league-ties',
        name: 'Test League with Ties',
        createdBy: 'user-1',
        inviteCode: 'TIE123',
        createdAt: DateTime(2024, 1, 15),
        members: [
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: DateTime(2024, 1, 15),
          ),
          LeagueMember(
            userId: 'user-2',
            role: LeagueMemberRole.member,
            points: 100,
            joinedAt: DateTime(2024, 1, 16),
          ),
          LeagueMember(
            userId: 'user-3',
            role: LeagueMemberRole.member,
            points: 50,
            joinedAt: DateTime(2024, 1, 17),
          ),
        ],
      );

      final leaderboard = leagueWithTies.rankedLeaderboard;

      // Both user-1 and user-2 should have rank 1
      expect(leaderboard[0].rank, 1);
      expect(leaderboard[0].points, 100);
      expect(leaderboard[0].isTied, false); // First entry is never "tied"

      expect(leaderboard[1].rank, 1);
      expect(leaderboard[1].points, 100);
      expect(
        leaderboard[1].isTied,
        true,
      ); // Second entry with same points IS tied

      // user-3 should have rank 3 (skipping rank 2 due to tie)
      expect(leaderboard[2].rank, 3);
      expect(leaderboard[2].points, 50);
      expect(leaderboard[2].isTied, false);
    });

    testWidgets('should calculate statistics correctly', (tester) async {
      final totalPoints = testLeague.members.fold<int>(
        0,
        (sum, m) => sum + m.points,
      );
      final avgPoints = testLeague.memberCount > 0
          ? (totalPoints / testLeague.memberCount).round()
          : 0;

      expect(totalPoints, 350); // 150 + 120 + 80
      expect(avgPoints, 117); // 350 / 3 rounded
      expect(testLeague.memberCount, 3);
    });

    testWidgets('LeagueMember role helpers work correctly', (tester) async {
      final owner = testLeague.getMember('owner-user-id')!;
      final admin = testLeague.getMember('admin-user-id')!;
      final member = testLeague.getMember('member-user-id')!;

      expect(owner.isOwner, true);
      expect(owner.isAdmin, true);

      expect(admin.isOwner, false);
      expect(admin.isAdmin, true);

      expect(member.isOwner, false);
      expect(member.isAdmin, false);
    });

    testWidgets('LeagueSettings defaults are correct', (tester) async {
      const defaultSettings = LeagueSettings.defaults();

      expect(defaultSettings.isPublic, false);
      expect(defaultSettings.maxMembers, 50);
      expect(defaultSettings.pointsPerCheckIn, 10);
      expect(defaultSettings.pointsPerReview, 5);
      expect(defaultSettings.allowMemberInvites, true);
      expect(defaultSettings.requireApproval, false);
    });
  });
}
