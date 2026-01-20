import 'package:flutter_test/flutter_test.dart';
import 'package:burgerrats/features/leagues/domain/entities/league_entity.dart';
import 'package:burgerrats/features/leagues/domain/entities/leaderboard_entry.dart';

void main() {
  group('LeaderboardEntry', () {
    test('should have correct properties from member', () {
      final member = LeagueMember(
        userId: 'user-123',
        role: LeagueMemberRole.member,
        points: 100,
        joinedAt: DateTime(2024, 1, 1),
      );

      final entry = LeaderboardEntry(
        rank: 1,
        member: member,
        isTied: false,
        checkInCount: 10,
      );

      expect(entry.rank, 1);
      expect(entry.userId, 'user-123');
      expect(entry.points, 100);
      expect(entry.role, LeagueMemberRole.member);
      expect(entry.joinedAt, DateTime(2024, 1, 1));
      expect(entry.isTied, false);
      expect(entry.checkInCount, 10);
    });

    test('copyWith should create a copy with updated fields', () {
      final member = LeagueMember(
        userId: 'user-123',
        role: LeagueMemberRole.member,
        points: 100,
        joinedAt: DateTime(2024, 1, 1),
      );

      final entry = LeaderboardEntry(
        rank: 1,
        member: member,
        isTied: false,
        checkInCount: 10,
      );

      final updated = entry.copyWith(rank: 2, isTied: true);

      expect(updated.rank, 2);
      expect(updated.isTied, true);
      expect(updated.userId, 'user-123'); // unchanged
      expect(updated.points, 100); // unchanged
    });

    test('equality should work correctly', () {
      final member = LeagueMember(
        userId: 'user-123',
        role: LeagueMemberRole.member,
        points: 100,
        joinedAt: DateTime(2024, 1, 1),
      );

      final entry1 = LeaderboardEntry(
        rank: 1,
        member: member,
        isTied: false,
        checkInCount: 10,
      );

      final entry2 = LeaderboardEntry(
        rank: 1,
        member: member,
        isTied: false,
        checkInCount: 10,
      );

      expect(entry1, entry2);
      expect(entry1.hashCode, entry2.hashCode);
    });
  });

  group('LeagueLeaderboardExtension', () {
    LeagueEntity createLeagueWithMembers(List<LeagueMember> members) {
      return LeagueEntity(
        id: 'league-1',
        name: 'Test League',
        createdBy: members.isNotEmpty ? members.first.userId : 'owner',
        members: members,
        inviteCode: 'TEST1234',
        createdAt: DateTime(2024, 1, 1),
      );
    }

    group('rankedLeaderboard', () {
      test('should return empty list for league with no members', () {
        final league = createLeagueWithMembers([]);

        expect(league.rankedLeaderboard, isEmpty);
      });

      test('should rank single member as first', () {
        final league = createLeagueWithMembers([
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: DateTime(2024, 1, 1),
          ),
        ]);

        final leaderboard = league.rankedLeaderboard;

        expect(leaderboard.length, 1);
        expect(leaderboard[0].rank, 1);
        expect(leaderboard[0].userId, 'user-1');
        expect(leaderboard[0].isTied, false);
      });

      test('should sort members by points descending', () {
        final league = createLeagueWithMembers([
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 50,
            joinedAt: DateTime(2024, 1, 1),
          ),
          LeagueMember(
            userId: 'user-2',
            role: LeagueMemberRole.member,
            points: 150,
            joinedAt: DateTime(2024, 1, 2),
          ),
          LeagueMember(
            userId: 'user-3',
            role: LeagueMemberRole.member,
            points: 75,
            joinedAt: DateTime(2024, 1, 3),
          ),
        ]);

        final leaderboard = league.rankedLeaderboard;

        expect(leaderboard[0].userId, 'user-2');
        expect(leaderboard[0].points, 150);
        expect(leaderboard[0].rank, 1);

        expect(leaderboard[1].userId, 'user-3');
        expect(leaderboard[1].points, 75);
        expect(leaderboard[1].rank, 2);

        expect(leaderboard[2].userId, 'user-1');
        expect(leaderboard[2].points, 50);
        expect(leaderboard[2].rank, 3);
      });

      test('should handle ties - members with same points share same rank', () {
        final league = createLeagueWithMembers([
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: DateTime(2024, 1, 1),
          ),
          LeagueMember(
            userId: 'user-2',
            role: LeagueMemberRole.member,
            points: 100,
            joinedAt: DateTime(2024, 1, 2),
          ),
          LeagueMember(
            userId: 'user-3',
            role: LeagueMemberRole.member,
            points: 50,
            joinedAt: DateTime(2024, 1, 3),
          ),
        ]);

        final leaderboard = league.rankedLeaderboard;

        // user-1 and user-2 should both be rank 1 (tied)
        expect(leaderboard[0].rank, 1);
        expect(leaderboard[0].isTied, false); // First entry is not marked as tied
        expect(leaderboard[1].rank, 1);
        expect(leaderboard[1].isTied, true); // Second entry is tied with first

        // user-3 should be rank 3 (skipping rank 2)
        expect(leaderboard[2].rank, 3);
        expect(leaderboard[2].isTied, false);
      });

      test('should handle multiple ties correctly', () {
        final league = createLeagueWithMembers([
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: DateTime(2024, 1, 1),
          ),
          LeagueMember(
            userId: 'user-2',
            role: LeagueMemberRole.member,
            points: 100,
            joinedAt: DateTime(2024, 1, 2),
          ),
          LeagueMember(
            userId: 'user-3',
            role: LeagueMemberRole.member,
            points: 100,
            joinedAt: DateTime(2024, 1, 3),
          ),
          LeagueMember(
            userId: 'user-4',
            role: LeagueMemberRole.member,
            points: 50,
            joinedAt: DateTime(2024, 1, 4),
          ),
          LeagueMember(
            userId: 'user-5',
            role: LeagueMemberRole.member,
            points: 50,
            joinedAt: DateTime(2024, 1, 5),
          ),
        ]);

        final leaderboard = league.rankedLeaderboard;

        // First three should all be rank 1
        expect(leaderboard[0].rank, 1);
        expect(leaderboard[0].isTied, false);
        expect(leaderboard[1].rank, 1);
        expect(leaderboard[1].isTied, true);
        expect(leaderboard[2].rank, 1);
        expect(leaderboard[2].isTied, true);

        // Fourth and fifth should be rank 4 (tied)
        expect(leaderboard[3].rank, 4);
        expect(leaderboard[3].isTied, false);
        expect(leaderboard[4].rank, 4);
        expect(leaderboard[4].isTied, true);
      });

      test('should use join date as secondary sort for ties (earlier first)', () {
        final league = createLeagueWithMembers([
          LeagueMember(
            userId: 'user-late',
            role: LeagueMemberRole.member,
            points: 100,
            joinedAt: DateTime(2024, 3, 1),
          ),
          LeagueMember(
            userId: 'user-early',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: DateTime(2024, 1, 1),
          ),
          LeagueMember(
            userId: 'user-mid',
            role: LeagueMemberRole.member,
            points: 100,
            joinedAt: DateTime(2024, 2, 1),
          ),
        ]);

        final leaderboard = league.rankedLeaderboard;

        // All have same points, so sorted by join date (earlier first)
        expect(leaderboard[0].userId, 'user-early');
        expect(leaderboard[1].userId, 'user-mid');
        expect(leaderboard[2].userId, 'user-late');

        // All share rank 1 (tied)
        expect(leaderboard[0].rank, 1);
        expect(leaderboard[1].rank, 1);
        expect(leaderboard[2].rank, 1);
      });

      test('should handle zero points correctly', () {
        final league = createLeagueWithMembers([
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 0,
            joinedAt: DateTime(2024, 1, 1),
          ),
          LeagueMember(
            userId: 'user-2',
            role: LeagueMemberRole.member,
            points: 0,
            joinedAt: DateTime(2024, 1, 2),
          ),
        ]);

        final leaderboard = league.rankedLeaderboard;

        expect(leaderboard[0].rank, 1);
        expect(leaderboard[1].rank, 1);
        expect(leaderboard[1].isTied, true);
      });
    });

    group('getUserRank', () {
      test('should return correct rank for user', () {
        final league = createLeagueWithMembers([
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: DateTime(2024, 1, 1),
          ),
          LeagueMember(
            userId: 'user-2',
            role: LeagueMemberRole.member,
            points: 50,
            joinedAt: DateTime(2024, 1, 2),
          ),
        ]);

        expect(league.getUserRank('user-1'), 1);
        expect(league.getUserRank('user-2'), 2);
      });

      test('should return null for non-member', () {
        final league = createLeagueWithMembers([
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: DateTime(2024, 1, 1),
          ),
        ]);

        expect(league.getUserRank('non-existent'), isNull);
      });

      test('should return correct rank for tied users', () {
        final league = createLeagueWithMembers([
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: DateTime(2024, 1, 1),
          ),
          LeagueMember(
            userId: 'user-2',
            role: LeagueMemberRole.member,
            points: 100,
            joinedAt: DateTime(2024, 1, 2),
          ),
        ]);

        // Both tied users should have rank 1
        expect(league.getUserRank('user-1'), 1);
        expect(league.getUserRank('user-2'), 1);
      });
    });

    group('getUserLeaderboardEntry', () {
      test('should return full entry for user', () {
        final league = createLeagueWithMembers([
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: DateTime(2024, 1, 1),
          ),
        ]);

        final entry = league.getUserLeaderboardEntry('user-1');

        expect(entry, isNotNull);
        expect(entry!.rank, 1);
        expect(entry.userId, 'user-1');
        expect(entry.points, 100);
      });

      test('should return null for non-member', () {
        final league = createLeagueWithMembers([
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: DateTime(2024, 1, 1),
          ),
        ]);

        expect(league.getUserLeaderboardEntry('non-existent'), isNull);
      });
    });

    group('getTopEntries', () {
      test('should return top N entries', () {
        final league = createLeagueWithMembers([
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: DateTime(2024, 1, 1),
          ),
          LeagueMember(
            userId: 'user-2',
            role: LeagueMemberRole.member,
            points: 80,
            joinedAt: DateTime(2024, 1, 2),
          ),
          LeagueMember(
            userId: 'user-3',
            role: LeagueMemberRole.member,
            points: 60,
            joinedAt: DateTime(2024, 1, 3),
          ),
          LeagueMember(
            userId: 'user-4',
            role: LeagueMemberRole.member,
            points: 40,
            joinedAt: DateTime(2024, 1, 4),
          ),
        ]);

        final top2 = league.getTopEntries(2);

        expect(top2.length, 2);
        expect(top2[0].userId, 'user-1');
        expect(top2[1].userId, 'user-2');
      });

      test('should return all entries if count exceeds member count', () {
        final league = createLeagueWithMembers([
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: DateTime(2024, 1, 1),
          ),
          LeagueMember(
            userId: 'user-2',
            role: LeagueMemberRole.member,
            points: 80,
            joinedAt: DateTime(2024, 1, 2),
          ),
        ]);

        final top10 = league.getTopEntries(10);

        expect(top10.length, 2);
      });
    });
  });
}
