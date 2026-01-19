import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgerrats/features/leagues/data/repositories/league_repository_impl.dart';
import 'package:burgerrats/features/leagues/domain/entities/league_entity.dart';
import 'package:burgerrats/core/errors/exceptions.dart';
import 'package:burgerrats/core/services/invite_code_generator_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late InviteCodeGeneratorService inviteCodeService;
  late LeagueRepositoryImpl repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    inviteCodeService = InviteCodeGeneratorService(fakeFirestore);
    repository = LeagueRepositoryImpl(fakeFirestore, inviteCodeService);
  });

  group('LeagueRepositoryImpl', () {
    group('createLeague', () {
      test('should create a new league and return it', () async {
        final league = await repository.createLeague(
          name: 'Test League',
          description: 'A test league',
          createdBy: 'user-123',
          settings: const LeagueSettings(
            isPublic: true,
            maxMembers: 25,
          ),
        );

        expect(league.name, 'Test League');
        expect(league.description, 'A test league');
        expect(league.createdBy, 'user-123');
        expect(league.settings.isPublic, true);
        expect(league.settings.maxMembers, 25);
        expect(league.members.length, 1);
        expect(league.members.first.userId, 'user-123');
        expect(league.members.first.role, LeagueMemberRole.owner);
        expect(league.inviteCode.length, greaterThanOrEqualTo(6));
        expect(league.inviteCode.length, lessThanOrEqualTo(8));
        expect(league.id, isNotEmpty);
      });

      test('should create league with default settings if not provided', () async {
        final league = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        expect(league.settings.isPublic, false);
        expect(league.settings.maxMembers, 50);
        expect(league.settings.pointsPerCheckIn, 10);
        expect(league.settings.pointsPerReview, 5);
      });
    });

    group('getLeagueById', () {
      test('should return league when it exists', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        final retrieved = await repository.getLeagueById(created.id);

        expect(retrieved, isNotNull);
        expect(retrieved!.id, created.id);
        expect(retrieved.name, 'Test League');
      });

      test('should return null when league does not exist', () async {
        final retrieved = await repository.getLeagueById('non-existent');

        expect(retrieved, isNull);
      });
    });

    group('getLeagueByInviteCode', () {
      test('should return league when invite code matches', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        final retrieved = await repository.getLeagueByInviteCode(created.inviteCode);

        expect(retrieved, isNotNull);
        expect(retrieved!.id, created.id);
        expect(retrieved.inviteCode, created.inviteCode);
      });

      test('should return league when invite code matches (case insensitive)', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        final retrieved = await repository.getLeagueByInviteCode(
          created.inviteCode.toLowerCase(),
        );

        expect(retrieved, isNotNull);
        expect(retrieved!.id, created.id);
      });

      test('should return null when invite code does not exist', () async {
        final retrieved = await repository.getLeagueByInviteCode('INVALID');

        expect(retrieved, isNull);
      });
    });

    group('updateLeague', () {
      test('should update league name and description', () async {
        final created = await repository.createLeague(
          name: 'Original Name',
          description: 'Original description',
          createdBy: 'user-123',
        );

        final updated = created.copyWith(
          name: 'Updated Name',
          description: 'Updated description',
        );

        await repository.updateLeague(updated);

        final retrieved = await repository.getLeagueById(created.id);

        expect(retrieved!.name, 'Updated Name');
        expect(retrieved.description, 'Updated description');
      });
    });

    group('deleteLeague', () {
      test('should delete league', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        await repository.deleteLeague(created.id);

        final retrieved = await repository.getLeagueById(created.id);

        expect(retrieved, isNull);
      });
    });

    group('getLeaguesForUser', () {
      test('should return leagues where user is a member', () async {
        await repository.createLeague(
          name: 'League 1',
          createdBy: 'user-123',
        );

        await repository.createLeague(
          name: 'League 2',
          createdBy: 'user-456',
        );

        final leagues = await repository.getLeaguesForUser('user-123');

        expect(leagues.length, 1);
        expect(leagues.first.name, 'League 1');
      });

      test('should return empty list when user has no leagues', () async {
        await repository.createLeague(
          name: 'League 1',
          createdBy: 'user-456',
        );

        final leagues = await repository.getLeaguesForUser('user-123');

        expect(leagues, isEmpty);
      });
    });

    group('getPublicLeagues', () {
      test('should return only public leagues', () async {
        await repository.createLeague(
          name: 'Public League',
          createdBy: 'user-123',
          settings: const LeagueSettings(isPublic: true),
        );

        await repository.createLeague(
          name: 'Private League',
          createdBy: 'user-456',
          settings: const LeagueSettings(isPublic: false),
        );

        final leagues = await repository.getPublicLeagues();

        expect(leagues.length, 1);
        expect(leagues.first.name, 'Public League');
      });
    });

    group('addMember', () {
      test('should add member to league', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        await repository.addMember(
          leagueId: created.id,
          userId: 'user-456',
        );

        final retrieved = await repository.getLeagueById(created.id);

        expect(retrieved!.members.length, 2);
        expect(retrieved.isMember('user-456'), true);
        expect(retrieved.getMember('user-456')!.role, LeagueMemberRole.member);
      });

      test('should throw when user is already a member', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        expect(
          () => repository.addMember(
            leagueId: created.id,
            userId: 'user-123',
          ),
          throwsA(isA<BusinessException>()),
        );
      });

      test('should throw when league is full', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
          settings: const LeagueSettings(maxMembers: 1),
        );

        expect(
          () => repository.addMember(
            leagueId: created.id,
            userId: 'user-456',
          ),
          throwsA(isA<BusinessException>()),
        );
      });

      test('should throw when league does not exist', () async {
        expect(
          () => repository.addMember(
            leagueId: 'non-existent',
            userId: 'user-456',
          ),
          throwsA(isA<BusinessException>()),
        );
      });
    });

    group('removeMember', () {
      test('should remove member from league', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        await repository.addMember(
          leagueId: created.id,
          userId: 'user-456',
        );

        await repository.removeMember(
          leagueId: created.id,
          userId: 'user-456',
        );

        final retrieved = await repository.getLeagueById(created.id);

        expect(retrieved!.members.length, 1);
        expect(retrieved.isMember('user-456'), false);
      });

      test('should throw when trying to remove owner', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        expect(
          () => repository.removeMember(
            leagueId: created.id,
            userId: 'user-123',
          ),
          throwsA(isA<BusinessException>()),
        );
      });

      test('should throw when user is not a member', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        expect(
          () => repository.removeMember(
            leagueId: created.id,
            userId: 'user-456',
          ),
          throwsA(isA<BusinessException>()),
        );
      });
    });

    group('updateMemberRole', () {
      test('should update member role', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        await repository.addMember(
          leagueId: created.id,
          userId: 'user-456',
        );

        await repository.updateMemberRole(
          leagueId: created.id,
          userId: 'user-456',
          newRole: LeagueMemberRole.admin,
        );

        final retrieved = await repository.getLeagueById(created.id);
        final member = retrieved!.getMember('user-456');

        expect(member!.role, LeagueMemberRole.admin);
      });

      test('should throw when trying to change owner role', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        expect(
          () => repository.updateMemberRole(
            leagueId: created.id,
            userId: 'user-123',
            newRole: LeagueMemberRole.admin,
          ),
          throwsA(isA<BusinessException>()),
        );
      });

      test('should throw when trying to assign owner role', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        await repository.addMember(
          leagueId: created.id,
          userId: 'user-456',
        );

        expect(
          () => repository.updateMemberRole(
            leagueId: created.id,
            userId: 'user-456',
            newRole: LeagueMemberRole.owner,
          ),
          throwsA(isA<BusinessException>()),
        );
      });
    });

    group('updateMemberPoints', () {
      test('should update member points', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        await repository.updateMemberPoints(
          leagueId: created.id,
          userId: 'user-123',
          points: 100,
        );

        final retrieved = await repository.getLeagueById(created.id);
        final member = retrieved!.getMember('user-123');

        expect(member!.points, 100);
      });
    });

    group('addMemberPoints', () {
      test('should add points to existing total', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        await repository.updateMemberPoints(
          leagueId: created.id,
          userId: 'user-123',
          points: 50,
        );

        await repository.addMemberPoints(
          leagueId: created.id,
          userId: 'user-123',
          pointsToAdd: 25,
        );

        final retrieved = await repository.getLeagueById(created.id);
        final member = retrieved!.getMember('user-123');

        expect(member!.points, 75);
      });
    });

    group('isMember', () {
      test('should return true when user is a member', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        final result = await repository.isMember(
          leagueId: created.id,
          userId: 'user-123',
        );

        expect(result, true);
      });

      test('should return false when user is not a member', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        final result = await repository.isMember(
          leagueId: created.id,
          userId: 'user-456',
        );

        expect(result, false);
      });

      test('should return false when league does not exist', () async {
        final result = await repository.isMember(
          leagueId: 'non-existent',
          userId: 'user-123',
        );

        expect(result, false);
      });
    });

    group('getLeaderboard', () {
      test('should return members sorted by points descending', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        await repository.addMember(leagueId: created.id, userId: 'user-456');
        await repository.addMember(leagueId: created.id, userId: 'user-789');

        await repository.updateMemberPoints(
          leagueId: created.id,
          userId: 'user-123',
          points: 50,
        );
        await repository.updateMemberPoints(
          leagueId: created.id,
          userId: 'user-456',
          points: 150,
        );
        await repository.updateMemberPoints(
          leagueId: created.id,
          userId: 'user-789',
          points: 75,
        );

        final leaderboard = await repository.getLeaderboard(created.id);

        expect(leaderboard[0].userId, 'user-456');
        expect(leaderboard[0].points, 150);
        expect(leaderboard[1].userId, 'user-789');
        expect(leaderboard[1].points, 75);
        expect(leaderboard[2].userId, 'user-123');
        expect(leaderboard[2].points, 50);
      });

      test('should throw when league does not exist', () async {
        expect(
          () => repository.getLeaderboard('non-existent'),
          throwsA(isA<BusinessException>()),
        );
      });
    });

    group('regenerateInviteCode', () {
      test('should generate a new invite code', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        final originalCode = created.inviteCode;

        final newCode = await repository.regenerateInviteCode(created.id);

        expect(newCode, isNot(originalCode));
        expect(newCode.length, greaterThanOrEqualTo(6));
        expect(newCode.length, lessThanOrEqualTo(8));

        final retrieved = await repository.getLeagueById(created.id);
        expect(retrieved!.inviteCode, newCode);
      });
    });

    group('watchLeague', () {
      test('should emit league updates', () async {
        final created = await repository.createLeague(
          name: 'Test League',
          createdBy: 'user-123',
        );

        final stream = repository.watchLeague(created.id);

        expect(
          stream,
          emitsInOrder([
            predicate<LeagueEntity?>((league) =>
                league != null && league.name == 'Test League'),
          ]),
        );
      });

      test('should emit null when league does not exist', () async {
        final stream = repository.watchLeague('non-existent');

        expect(stream, emits(isNull));
      });
    });

    group('watchLeaguesForUser', () {
      test('should emit leagues for user', () async {
        await repository.createLeague(
          name: 'League 1',
          createdBy: 'user-123',
        );

        final stream = repository.watchLeaguesForUser('user-123');

        expect(
          stream,
          emitsInOrder([
            predicate<List<LeagueEntity>>((leagues) =>
                leagues.length == 1 && leagues.first.name == 'League 1'),
          ]),
        );
      });
    });
  });
}
