import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgerrats/features/leagues/data/models/league_model.dart';
import 'package:burgerrats/features/leagues/domain/entities/league_entity.dart';

void main() {
  group('LeagueSettingsModel', () {
    test('should create from JSON', () {
      final json = {
        'isPublic': true,
        'maxMembers': 100,
        'pointsPerCheckIn': 20,
        'pointsPerReview': 10,
        'allowMemberInvites': false,
        'requireApproval': true,
      };

      final settings = LeagueSettingsModel.fromJson(json);

      expect(settings.isPublic, true);
      expect(settings.maxMembers, 100);
      expect(settings.pointsPerCheckIn, 20);
      expect(settings.pointsPerReview, 10);
      expect(settings.allowMemberInvites, false);
      expect(settings.requireApproval, true);
    });

    test('should handle missing JSON fields with defaults', () {
      final json = <String, dynamic>{};

      final settings = LeagueSettingsModel.fromJson(json);

      expect(settings.isPublic, false);
      expect(settings.maxMembers, 50);
      expect(settings.pointsPerCheckIn, 10);
      expect(settings.pointsPerReview, 5);
      expect(settings.allowMemberInvites, true);
      expect(settings.requireApproval, false);
    });

    test('should convert to JSON', () {
      const settings = LeagueSettingsModel(
        isPublic: true,
        maxMembers: 100,
        pointsPerCheckIn: 20,
        pointsPerReview: 10,
        allowMemberInvites: false,
        requireApproval: true,
      );

      final json = settings.toJson();

      expect(json['isPublic'], true);
      expect(json['maxMembers'], 100);
      expect(json['pointsPerCheckIn'], 20);
      expect(json['pointsPerReview'], 10);
      expect(json['allowMemberInvites'], false);
      expect(json['requireApproval'], true);
    });

    test('should create from entity', () {
      const entity = LeagueSettings(
        isPublic: true,
        maxMembers: 75,
      );

      final model = LeagueSettingsModel.fromEntity(entity);

      expect(model.isPublic, true);
      expect(model.maxMembers, 75);
    });

    test('should convert to entity', () {
      const model = LeagueSettingsModel(
        isPublic: true,
        maxMembers: 75,
      );

      final entity = model.toEntity();

      expect(entity.isPublic, true);
      expect(entity.maxMembers, 75);
      expect(entity, isA<LeagueSettings>());
    });

    test('should create default settings', () {
      final settings = LeagueSettingsModel.defaults();

      expect(settings.isPublic, false);
      expect(settings.maxMembers, 50);
      expect(settings.pointsPerCheckIn, 10);
      expect(settings.pointsPerReview, 5);
      expect(settings.allowMemberInvites, true);
      expect(settings.requireApproval, false);
    });
  });

  group('LeagueMemberModel', () {
    final joinedAt = DateTime(2024, 1, 15);
    final timestamp = Timestamp.fromDate(joinedAt);

    test('should create from JSON with Timestamp', () {
      final json = {
        'userId': 'user-123',
        'role': 'admin',
        'points': 150,
        'joinedAt': timestamp,
      };

      final member = LeagueMemberModel.fromJson(json);

      expect(member.userId, 'user-123');
      expect(member.role, LeagueMemberRole.admin);
      expect(member.points, 150);
      expect(member.joinedAt, joinedAt);
    });

    test('should create from JSON with ISO string date', () {
      final json = {
        'userId': 'user-123',
        'role': 'member',
        'points': 50,
        'joinedAt': '2024-01-15T00:00:00.000',
      };

      final member = LeagueMemberModel.fromJson(json);

      expect(member.userId, 'user-123');
      expect(member.role, LeagueMemberRole.member);
      expect(member.joinedAt.year, 2024);
      expect(member.joinedAt.month, 1);
      expect(member.joinedAt.day, 15);
    });

    test('should create from JSON with milliseconds timestamp', () {
      final millis = joinedAt.millisecondsSinceEpoch;
      final json = {
        'userId': 'user-123',
        'role': 'owner',
        'points': 200,
        'joinedAt': millis,
      };

      final member = LeagueMemberModel.fromJson(json);

      expect(member.userId, 'user-123');
      expect(member.role, LeagueMemberRole.owner);
      expect(member.joinedAt, joinedAt);
    });

    test('should handle missing optional fields', () {
      final json = {
        'userId': 'user-123',
        'joinedAt': timestamp,
      };

      final member = LeagueMemberModel.fromJson(json);

      expect(member.userId, 'user-123');
      expect(member.role, LeagueMemberRole.member);
      expect(member.points, 0);
    });

    test('should handle invalid role with default', () {
      final json = {
        'userId': 'user-123',
        'role': 'invalid_role',
        'joinedAt': timestamp,
      };

      final member = LeagueMemberModel.fromJson(json);

      expect(member.role, LeagueMemberRole.member);
    });

    test('should convert to JSON', () {
      final member = LeagueMemberModel(
        userId: 'user-123',
        role: LeagueMemberRole.admin,
        points: 150,
        joinedAt: joinedAt,
      );

      final json = member.toJson();

      expect(json['userId'], 'user-123');
      expect(json['role'], 'admin');
      expect(json['points'], 150);
      expect(json['joinedAt'], isA<Timestamp>());
      expect((json['joinedAt'] as Timestamp).toDate(), joinedAt);
    });

    test('should create from entity', () {
      final entity = LeagueMember(
        userId: 'user-123',
        role: LeagueMemberRole.admin,
        points: 150,
        joinedAt: joinedAt,
      );

      final model = LeagueMemberModel.fromEntity(entity);

      expect(model.userId, 'user-123');
      expect(model.role, LeagueMemberRole.admin);
      expect(model.points, 150);
      expect(model.joinedAt, joinedAt);
    });

    test('should convert to entity', () {
      final model = LeagueMemberModel(
        userId: 'user-123',
        role: LeagueMemberRole.admin,
        points: 150,
        joinedAt: joinedAt,
      );

      final entity = model.toEntity();

      expect(entity.userId, 'user-123');
      expect(entity.role, LeagueMemberRole.admin);
      expect(entity.points, 150);
      expect(entity.joinedAt, joinedAt);
      expect(entity, isA<LeagueMember>());
    });

    test('should create new member with defaults', () {
      final member = LeagueMemberModel.newMember(
        userId: 'new-user',
        role: LeagueMemberRole.owner,
      );

      expect(member.userId, 'new-user');
      expect(member.role, LeagueMemberRole.owner);
      expect(member.points, 0);
      expect(member.joinedAt, isNotNull);
    });
  });

  group('LeagueModel', () {
    final createdAt = DateTime(2024, 1, 15);
    final timestamp = Timestamp.fromDate(createdAt);
    final memberJoinedAt = DateTime(2024, 1, 16);
    final memberTimestamp = Timestamp.fromDate(memberJoinedAt);

    test('should create from JSON with Timestamp', () {
      final json = {
        'id': 'league-123',
        'name': 'Burger Masters',
        'description': 'The ultimate burger league',
        'createdBy': 'creator-uid',
        'inviteCode': 'ABC123',
        'createdAt': timestamp,
        'members': [
          {
            'userId': 'user-1',
            'role': 'owner',
            'points': 100,
            'joinedAt': memberTimestamp,
          },
          {
            'userId': 'user-2',
            'role': 'member',
            'points': 50,
            'joinedAt': memberTimestamp,
          },
        ],
        'settings': {
          'isPublic': true,
          'maxMembers': 100,
          'pointsPerCheckIn': 15,
          'pointsPerReview': 8,
          'allowMemberInvites': true,
          'requireApproval': false,
        },
      };

      final league = LeagueModel.fromJson(json);

      expect(league.id, 'league-123');
      expect(league.name, 'Burger Masters');
      expect(league.description, 'The ultimate burger league');
      expect(league.createdBy, 'creator-uid');
      expect(league.inviteCode, 'ABC123');
      expect(league.createdAt, createdAt);
      expect(league.members.length, 2);
      expect(league.members[0].userId, 'user-1');
      expect(league.members[0].role, LeagueMemberRole.owner);
      expect(league.members[1].userId, 'user-2');
      expect(league.members[1].role, LeagueMemberRole.member);
      expect(league.settings.isPublic, true);
      expect(league.settings.maxMembers, 100);
    });

    test('should create from JSON with id parameter', () {
      final json = {
        'name': 'Burger Masters',
        'createdBy': 'creator-uid',
        'inviteCode': 'ABC123',
        'createdAt': timestamp,
        'members': <dynamic>[],
      };

      final league = LeagueModel.fromJson(json, 'provided-id');

      expect(league.id, 'provided-id');
      expect(league.name, 'Burger Masters');
    });

    test('should handle missing optional fields', () {
      final json = {
        'id': 'league-123',
        'name': 'Burger Masters',
        'createdBy': 'creator-uid',
        'inviteCode': 'ABC123',
        'createdAt': timestamp,
      };

      final league = LeagueModel.fromJson(json);

      expect(league.description, null);
      expect(league.members, isEmpty);
      expect(league.settings, isA<LeagueSettings>());
      expect(league.settings.maxMembers, 50); // default
    });

    test('should handle ISO string date', () {
      final json = {
        'id': 'league-123',
        'name': 'Burger Masters',
        'createdBy': 'creator-uid',
        'inviteCode': 'ABC123',
        'createdAt': '2024-01-15T00:00:00.000',
        'members': <dynamic>[],
      };

      final league = LeagueModel.fromJson(json);

      expect(league.createdAt.year, 2024);
      expect(league.createdAt.month, 1);
      expect(league.createdAt.day, 15);
    });

    test('should handle milliseconds timestamp', () {
      final millis = createdAt.millisecondsSinceEpoch;
      final json = {
        'id': 'league-123',
        'name': 'Burger Masters',
        'createdBy': 'creator-uid',
        'inviteCode': 'ABC123',
        'createdAt': millis,
        'members': <dynamic>[],
      };

      final league = LeagueModel.fromJson(json);

      expect(league.createdAt, createdAt);
    });

    test('should convert to JSON', () {
      final league = LeagueModel(
        id: 'league-123',
        name: 'Burger Masters',
        description: 'The ultimate burger league',
        createdBy: 'creator-uid',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMemberModel(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: memberJoinedAt,
          ),
        ],
        settings: const LeagueSettingsModel(
          isPublic: true,
          maxMembers: 100,
        ),
      );

      final json = league.toJson();

      expect(json['id'], 'league-123');
      expect(json['name'], 'Burger Masters');
      expect(json['description'], 'The ultimate burger league');
      expect(json['createdBy'], 'creator-uid');
      expect(json['inviteCode'], 'ABC123');
      expect(json['createdAt'], isA<Timestamp>());
      expect((json['createdAt'] as Timestamp).toDate(), createdAt);
      expect(json['members'], isA<List>());
      expect((json['members'] as List).length, 1);
      expect(json['settings'], isA<Map>());
      expect(json['settings']['isPublic'], true);
      expect(json['settings']['maxMembers'], 100);
    });

    test('should convert to JSON for update (excludes id, createdBy, inviteCode, createdAt)', () {
      final league = LeagueModel(
        id: 'league-123',
        name: 'Burger Masters',
        description: 'Updated description',
        createdBy: 'creator-uid',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMemberModel(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: memberJoinedAt,
          ),
        ],
        settings: const LeagueSettingsModel(
          isPublic: true,
          maxMembers: 100,
        ),
      );

      final json = league.toJsonForUpdate();

      expect(json.containsKey('id'), false);
      expect(json.containsKey('createdBy'), false);
      expect(json.containsKey('inviteCode'), false);
      expect(json.containsKey('createdAt'), false);
      expect(json['name'], 'Burger Masters');
      expect(json['description'], 'Updated description');
      expect(json['members'], isA<List>());
      expect(json['settings'], isA<Map>());
    });

    test('should create new league', () {
      final league = LeagueModel.newLeague(
        id: 'new-league',
        name: 'New League',
        description: 'A new league',
        createdBy: 'creator-uid',
        inviteCode: 'NEW123',
        settings: const LeagueSettings(
          isPublic: true,
          maxMembers: 25,
        ),
      );

      expect(league.id, 'new-league');
      expect(league.name, 'New League');
      expect(league.description, 'A new league');
      expect(league.createdBy, 'creator-uid');
      expect(league.inviteCode, 'NEW123');
      expect(league.members.length, 1);
      expect(league.members[0].userId, 'creator-uid');
      expect(league.members[0].role, LeagueMemberRole.owner);
      expect(league.members[0].points, 0);
      expect(league.settings.isPublic, true);
      expect(league.settings.maxMembers, 25);
    });

    test('should create from entity', () {
      final entity = LeagueEntity(
        id: 'league-123',
        name: 'Burger Masters',
        description: 'The ultimate burger league',
        createdBy: 'creator-uid',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMember(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: memberJoinedAt,
          ),
        ],
        settings: const LeagueSettings(
          isPublic: true,
          maxMembers: 100,
        ),
      );

      final model = LeagueModel.fromEntity(entity);

      expect(model.id, 'league-123');
      expect(model.name, 'Burger Masters');
      expect(model.description, 'The ultimate burger league');
      expect(model.createdBy, 'creator-uid');
      expect(model.inviteCode, 'ABC123');
      expect(model.createdAt, createdAt);
      expect(model.members.length, 1);
      expect(model.settings.isPublic, true);
    });

    test('should convert to entity', () {
      final model = LeagueModel(
        id: 'league-123',
        name: 'Burger Masters',
        description: 'The ultimate burger league',
        createdBy: 'creator-uid',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMemberModel(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: memberJoinedAt,
          ),
        ],
        settings: const LeagueSettingsModel(
          isPublic: true,
          maxMembers: 100,
        ),
      );

      final entity = model.toEntity();

      expect(entity.id, 'league-123');
      expect(entity.name, 'Burger Masters');
      expect(entity.description, 'The ultimate burger league');
      expect(entity.createdBy, 'creator-uid');
      expect(entity.inviteCode, 'ABC123');
      expect(entity.createdAt, createdAt);
      expect(entity.members.length, 1);
      expect(entity.settings.isPublic, true);
      expect(entity, isA<LeagueEntity>());
    });

    test('copyWith should create a copy with updated fields', () {
      final league = LeagueModel(
        id: 'league-123',
        name: 'Burger Masters',
        createdBy: 'creator-uid',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: const [],
      );

      final updatedLeague = league.copyWith(
        name: 'Updated Name',
        description: 'New description',
      );

      expect(updatedLeague.id, 'league-123');
      expect(updatedLeague.name, 'Updated Name');
      expect(updatedLeague.description, 'New description');
      expect(updatedLeague.createdBy, 'creator-uid');
      expect(updatedLeague, isA<LeagueModel>());
    });

    test('should roundtrip through JSON', () {
      final original = LeagueModel(
        id: 'league-123',
        name: 'Burger Masters',
        description: 'The ultimate burger league',
        createdBy: 'creator-uid',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMemberModel(
            userId: 'user-1',
            role: LeagueMemberRole.owner,
            points: 100,
            joinedAt: memberJoinedAt,
          ),
          LeagueMemberModel(
            userId: 'user-2',
            role: LeagueMemberRole.admin,
            points: 75,
            joinedAt: memberJoinedAt,
          ),
          LeagueMemberModel(
            userId: 'user-3',
            role: LeagueMemberRole.member,
            points: 50,
            joinedAt: memberJoinedAt,
          ),
        ],
        settings: const LeagueSettingsModel(
          isPublic: true,
          maxMembers: 100,
          pointsPerCheckIn: 15,
          pointsPerReview: 8,
          allowMemberInvites: false,
          requireApproval: true,
        ),
      );

      final json = original.toJson();
      final restored = LeagueModel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.description, original.description);
      expect(restored.createdBy, original.createdBy);
      expect(restored.inviteCode, original.inviteCode);
      expect(restored.createdAt, original.createdAt);
      expect(restored.members.length, original.members.length);
      expect(restored.members[0].userId, original.members[0].userId);
      expect(restored.members[0].role, original.members[0].role);
      expect(restored.members[0].points, original.members[0].points);
      expect(restored.settings.isPublic, original.settings.isPublic);
      expect(restored.settings.maxMembers, original.settings.maxMembers);
      expect(restored.settings.pointsPerCheckIn, original.settings.pointsPerCheckIn);
      expect(restored.settings.requireApproval, original.settings.requireApproval);
    });
  });

  group('LeagueEntity helper methods', () {
    final createdAt = DateTime(2024, 1, 15);
    final joinedAt = DateTime(2024, 1, 16);

    test('memberCount should return number of members', () {
      final league = LeagueEntity(
        id: 'league-123',
        name: 'Test League',
        createdBy: 'creator',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt),
          LeagueMember(userId: 'user-2', role: LeagueMemberRole.member, joinedAt: joinedAt),
          LeagueMember(userId: 'user-3', role: LeagueMemberRole.member, joinedAt: joinedAt),
        ],
      );

      expect(league.memberCount, 3);
    });

    test('isFull should return true when at max capacity', () {
      final league = LeagueEntity(
        id: 'league-123',
        name: 'Test League',
        createdBy: 'creator',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt),
          LeagueMember(userId: 'user-2', role: LeagueMemberRole.member, joinedAt: joinedAt),
        ],
        settings: const LeagueSettings(maxMembers: 2),
      );

      expect(league.isFull, true);
      expect(league.canJoin, false);
    });

    test('isFull should return false when under capacity', () {
      final league = LeagueEntity(
        id: 'league-123',
        name: 'Test League',
        createdBy: 'creator',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt),
        ],
        settings: const LeagueSettings(maxMembers: 50),
      );

      expect(league.isFull, false);
      expect(league.canJoin, true);
    });

    test('getMember should return member if found', () {
      final league = LeagueEntity(
        id: 'league-123',
        name: 'Test League',
        createdBy: 'creator',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, points: 100, joinedAt: joinedAt),
          LeagueMember(userId: 'user-2', role: LeagueMemberRole.member, points: 50, joinedAt: joinedAt),
        ],
      );

      final member = league.getMember('user-2');

      expect(member, isNotNull);
      expect(member!.userId, 'user-2');
      expect(member.points, 50);
    });

    test('getMember should return null if not found', () {
      final league = LeagueEntity(
        id: 'league-123',
        name: 'Test League',
        createdBy: 'creator',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt),
        ],
      );

      final member = league.getMember('non-existent');

      expect(member, isNull);
    });

    test('isMember should return true for members', () {
      final league = LeagueEntity(
        id: 'league-123',
        name: 'Test League',
        createdBy: 'creator',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt),
        ],
      );

      expect(league.isMember('user-1'), true);
      expect(league.isMember('user-2'), false);
    });

    test('isAdmin should return true for admin and owner roles', () {
      final league = LeagueEntity(
        id: 'league-123',
        name: 'Test League',
        createdBy: 'user-1',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt),
          LeagueMember(userId: 'user-2', role: LeagueMemberRole.admin, joinedAt: joinedAt),
          LeagueMember(userId: 'user-3', role: LeagueMemberRole.member, joinedAt: joinedAt),
        ],
      );

      expect(league.isAdmin('user-1'), true);
      expect(league.isAdmin('user-2'), true);
      expect(league.isAdmin('user-3'), false);
      expect(league.isAdmin('non-existent'), false);
    });

    test('isOwner should return true only for creator', () {
      final league = LeagueEntity(
        id: 'league-123',
        name: 'Test League',
        createdBy: 'creator-uid',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMember(userId: 'creator-uid', role: LeagueMemberRole.owner, joinedAt: joinedAt),
          LeagueMember(userId: 'user-2', role: LeagueMemberRole.admin, joinedAt: joinedAt),
        ],
      );

      expect(league.isOwner('creator-uid'), true);
      expect(league.isOwner('user-2'), false);
    });

    test('leaderboard should return members sorted by points descending', () {
      final league = LeagueEntity(
        id: 'league-123',
        name: 'Test League',
        createdBy: 'creator',
        inviteCode: 'ABC123',
        createdAt: createdAt,
        members: [
          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, points: 50, joinedAt: joinedAt),
          LeagueMember(userId: 'user-2', role: LeagueMemberRole.member, points: 150, joinedAt: joinedAt),
          LeagueMember(userId: 'user-3', role: LeagueMemberRole.member, points: 75, joinedAt: joinedAt),
        ],
      );

      final leaderboard = league.leaderboard;

      expect(leaderboard[0].userId, 'user-2');
      expect(leaderboard[0].points, 150);
      expect(leaderboard[1].userId, 'user-3');
      expect(leaderboard[1].points, 75);
      expect(leaderboard[2].userId, 'user-1');
      expect(leaderboard[2].points, 50);
    });
  });

  group('LeagueMember helper methods', () {
    final joinedAt = DateTime(2024, 1, 15);

    test('isAdmin should return true for admin and owner roles', () {
      final owner = LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt);
      final admin = LeagueMember(userId: 'user-2', role: LeagueMemberRole.admin, joinedAt: joinedAt);
      final member = LeagueMember(userId: 'user-3', role: LeagueMemberRole.member, joinedAt: joinedAt);

      expect(owner.isAdmin, true);
      expect(admin.isAdmin, true);
      expect(member.isAdmin, false);
    });

    test('isOwner should return true only for owner role', () {
      final owner = LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt);
      final admin = LeagueMember(userId: 'user-2', role: LeagueMemberRole.admin, joinedAt: joinedAt);
      final member = LeagueMember(userId: 'user-3', role: LeagueMemberRole.member, joinedAt: joinedAt);

      expect(owner.isOwner, true);
      expect(admin.isOwner, false);
      expect(member.isOwner, false);
    });

    test('newMember factory should create member with defaults', () {
      final member = LeagueMember.newMember(userId: 'new-user');

      expect(member.userId, 'new-user');
      expect(member.role, LeagueMemberRole.member);
      expect(member.points, 0);
      expect(member.joinedAt, isNotNull);
    });

    test('newMember factory should accept custom role', () {
      final member = LeagueMember.newMember(userId: 'new-admin', role: LeagueMemberRole.admin);

      expect(member.userId, 'new-admin');
      expect(member.role, LeagueMemberRole.admin);
    });
  });
}
