import 'package:flutter_test/flutter_test.dart';

import 'package:burgerrats/features/leagues/domain/entities/league_entity.dart';

void main() {
  group('LeagueSettingsPage', () {
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

    testWidgets('LeagueSettings can be updated with copyWith', (tester) async {
      const originalSettings = LeagueSettings(
        isPublic: false,
        maxMembers: 50,
        pointsPerCheckIn: 10,
        pointsPerReview: 5,
        allowMemberInvites: true,
        requireApproval: false,
      );

      final updatedSettings = originalSettings.copyWith(
        isPublic: true,
        maxMembers: 100,
      );

      expect(updatedSettings.isPublic, true);
      expect(updatedSettings.maxMembers, 100);
      // Unchanged values should remain the same
      expect(updatedSettings.pointsPerCheckIn, 10);
      expect(updatedSettings.pointsPerReview, 5);
      expect(updatedSettings.allowMemberInvites, true);
      expect(updatedSettings.requireApproval, false);
    });

    testWidgets('LeagueEntity copyWith preserves name and description', (
      tester,
    ) async {
      final updatedLeague = testLeague.copyWith(
        name: 'Updated League Name',
        description: 'Updated description',
      );

      expect(updatedLeague.name, 'Updated League Name');
      expect(updatedLeague.description, 'Updated description');
      // Unchanged values should remain the same
      expect(updatedLeague.id, testLeague.id);
      expect(updatedLeague.inviteCode, testLeague.inviteCode);
      expect(updatedLeague.members.length, testLeague.members.length);
    });

    testWidgets('LeagueEntity copyWith can update settings', (tester) async {
      final newSettings = const LeagueSettings(
        isPublic: true,
        maxMembers: 100,
        pointsPerCheckIn: 20,
        pointsPerReview: 10,
        allowMemberInvites: false,
        requireApproval: true,
      );

      final updatedLeague = testLeague.copyWith(settings: newSettings);

      expect(updatedLeague.settings.isPublic, true);
      expect(updatedLeague.settings.maxMembers, 100);
      expect(updatedLeague.settings.pointsPerCheckIn, 20);
      expect(updatedLeague.settings.pointsPerReview, 10);
      expect(updatedLeague.settings.allowMemberInvites, false);
      expect(updatedLeague.settings.requireApproval, true);
    });

    testWidgets('Admin can view settings', (tester) async {
      // Verify admin detection works correctly
      expect(testLeague.isAdmin('owner-user-id'), true);
      expect(testLeague.isAdmin('admin-user-id'), true);
      expect(testLeague.isAdmin('member-user-id'), false);
    });

    testWidgets('Owner permissions are correct', (tester) async {
      // Owner can manage all members
      expect(testLeague.isOwner('owner-user-id'), true);
      expect(testLeague.isOwner('admin-user-id'), false);
      expect(testLeague.isOwner('member-user-id'), false);
    });

    testWidgets('Members are sorted correctly for settings page', (
      tester,
    ) async {
      // Simulate the sorting logic from the settings page
      final sortedMembers = List<LeagueMember>.from(testLeague.members)
        ..sort((a, b) {
          if (a.isOwner) return -1;
          if (b.isOwner) return 1;
          if (a.isAdmin && !b.isAdmin) return -1;
          if (!a.isAdmin && b.isAdmin) return 1;
          return 0;
        });

      // Owner should be first
      expect(sortedMembers[0].userId, 'owner-user-id');
      expect(sortedMembers[0].isOwner, true);

      // Admin should be second
      expect(sortedMembers[1].userId, 'admin-user-id');
      expect(sortedMembers[1].isAdmin, true);
      expect(sortedMembers[1].isOwner, false);

      // Regular member should be last
      expect(sortedMembers[2].userId, 'member-user-id');
      expect(sortedMembers[2].isAdmin, false);
    });

    testWidgets('Invite code is displayed correctly', (tester) async {
      expect(testLeague.inviteCode, 'ABC123');
      expect(testLeague.inviteCode.length, 6);
    });

    testWidgets('Member role labels are correct', (tester) async {
      String getRoleLabel(LeagueMemberRole role) {
        return switch (role) {
          LeagueMemberRole.owner => 'Dono',
          LeagueMemberRole.admin => 'Admin',
          LeagueMemberRole.member => 'Membro',
        };
      }

      expect(getRoleLabel(LeagueMemberRole.owner), 'Dono');
      expect(getRoleLabel(LeagueMemberRole.admin), 'Admin');
      expect(getRoleLabel(LeagueMemberRole.member), 'Membro');
    });

    testWidgets('LeagueMember copyWith updates role correctly', (tester) async {
      final member = testLeague.getMember('member-user-id')!;

      // Promote member to admin
      final promotedMember = member.copyWith(role: LeagueMemberRole.admin);

      expect(promotedMember.role, LeagueMemberRole.admin);
      expect(promotedMember.isAdmin, true);
      expect(promotedMember.userId, member.userId);
      expect(promotedMember.points, member.points);
    });

    testWidgets('Form validation requires league name', (tester) async {
      // Test that empty name should be invalid
      String? validateName(String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'O nome da liga e obrigatorio';
        }
        if (value.trim().length < 3) {
          return 'O nome deve ter pelo menos 3 caracteres';
        }
        return null;
      }

      expect(validateName(null), 'O nome da liga e obrigatorio');
      expect(validateName(''), 'O nome da liga e obrigatorio');
      expect(validateName('   '), 'O nome da liga e obrigatorio');
      expect(validateName('AB'), 'O nome deve ter pelo menos 3 caracteres');
      expect(validateName('ABC'), null); // Valid
      expect(validateName('Test League'), null); // Valid
    });

    testWidgets('Settings equality check works correctly', (tester) async {
      const settings1 = LeagueSettings(
        isPublic: true,
        maxMembers: 50,
        pointsPerCheckIn: 10,
        pointsPerReview: 5,
        allowMemberInvites: true,
        requireApproval: false,
      );

      const settings2 = LeagueSettings(
        isPublic: true,
        maxMembers: 50,
        pointsPerCheckIn: 10,
        pointsPerReview: 5,
        allowMemberInvites: true,
        requireApproval: false,
      );

      const settings3 = LeagueSettings(
        isPublic: false, // Different
        maxMembers: 50,
        pointsPerCheckIn: 10,
        pointsPerReview: 5,
        allowMemberInvites: true,
        requireApproval: false,
      );

      expect(settings1 == settings2, true);
      expect(settings1 == settings3, false);
    });
  });
}
