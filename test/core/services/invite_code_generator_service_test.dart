import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgerrats/core/services/invite_code_generator_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late InviteCodeGeneratorService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    service = InviteCodeGeneratorService(fakeFirestore);
  });

  group('InviteCodeGeneratorService', () {
    group('generateCode', () {
      test('should generate code with default length of 8', () {
        final code = service.generateCode();

        expect(code.length, 8);
      });

      test('should generate code with specified length', () {
        final code = service.generateCode(length: 6);

        expect(code.length, 6);
      });

      test('should generate code with only allowed characters', () {
        final allowedChars = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

        for (int i = 0; i < 100; i++) {
          final code = service.generateCode();
          for (final char in code.split('')) {
            expect(
              allowedChars.contains(char),
              true,
              reason: 'Character "$char" is not allowed',
            );
          }
        }
      });

      test('should generate unique codes', () {
        final codes = <String>{};
        for (int i = 0; i < 100; i++) {
          codes.add(service.generateCode());
        }
        // With 8-character codes from a 32-character alphabet,
        // 100 codes should all be unique
        expect(codes.length, 100);
      });
    });

    group('generateUniqueCode', () {
      test('should generate a unique code', () async {
        final result = await service.generateUniqueCode();

        expect(result.code.length, greaterThanOrEqualTo(6));
        expect(result.code.length, lessThanOrEqualTo(8));
        expect(result.attemptsUsed, 1);
      });

      test('should avoid collision with existing code', () async {
        // Pre-populate a league with a specific invite code
        final existingCode = service.generateCode();
        await fakeFirestore.collection('leagues').add({
          'name': 'Existing League',
          'inviteCode': existingCode,
        });

        // Generate multiple codes to verify uniqueness
        for (int i = 0; i < 10; i++) {
          final result = await service.generateUniqueCode();
          expect(result.code, isNot(existingCode));
        }
      });

      test('should respect custom options', () async {
        final result = await service.generateUniqueCode(
          options: InviteCodeOptions.short,
        );

        expect(result.code.length, 6);
        expect(result.codeLength, 6);
      });

      test('should return attempts used', () async {
        final result = await service.generateUniqueCode();

        expect(result.attemptsUsed, greaterThanOrEqualTo(1));
        expect(result.attemptsUsed, lessThanOrEqualTo(10));
      });
    });

    group('isValidFormat', () {
      test('should return true for valid codes', () {
        // Only use characters from allowed set: ABCDEFGHJKMNPQRSTUVWXYZ23456789
        expect(service.isValidFormat('ABC234'), true);
        expect(service.isValidFormat('ABCD2345'), true);
        expect(service.isValidFormat('ABCDEF'), true);
        expect(service.isValidFormat('ABCDEFGH'), true);
      });

      test('should return false for codes that are too short', () {
        expect(service.isValidFormat('ABC23'), false);
        expect(service.isValidFormat('AB'), false);
        expect(service.isValidFormat(''), false);
      });

      test('should return false for codes that are too long', () {
        expect(service.isValidFormat('ABCDEFGH2'), false);
        expect(service.isValidFormat('ABCDEFGH23'), false);
      });

      test('should return false for codes with invalid characters', () {
        // Characters excluded from the allowed set: O, I, L, 0, 1
        expect(service.isValidFormat('ABC23O'), false); // Contains O
        expect(service.isValidFormat('ABC23I'), false); // Contains I
        expect(service.isValidFormat('ABC23L'), false); // Contains L
        expect(service.isValidFormat('ABC230'), false); // Contains 0
        expect(service.isValidFormat('ABC231'), false); // Contains 1
        expect(service.isValidFormat('abc234'), true); // Lowercase is converted
      });
    });

    group('normalizeCode', () {
      test('should convert to uppercase', () {
        expect(service.normalizeCode('abc123'), 'ABC123');
        expect(service.normalizeCode('AbCdEf'), 'ABCDEF');
      });

      test('should remove whitespace', () {
        expect(service.normalizeCode('ABC 123'), 'ABC123');
        expect(service.normalizeCode('AB C1 23'), 'ABC123');
        expect(service.normalizeCode(' ABC123 '), 'ABC123');
      });

      test('should handle combined cases', () {
        expect(service.normalizeCode(' abc 123 '), 'ABC123');
      });
    });

    group('isCodeAvailable', () {
      test('should return true when code is not in use', () async {
        final result = await service.isCodeAvailable('ABC12345');

        expect(result, true);
      });

      test('should return false when code is in use', () async {
        await fakeFirestore.collection('leagues').add({
          'name': 'Test League',
          'inviteCode': 'ABC12345',
        });

        final result = await service.isCodeAvailable('ABC12345');

        expect(result, false);
      });

      test('should be case insensitive', () async {
        await fakeFirestore.collection('leagues').add({
          'name': 'Test League',
          'inviteCode': 'ABC12345',
        });

        final result = await service.isCodeAvailable('abc12345');

        expect(result, false);
      });
    });

    group('InviteCodeOptions', () {
      test('defaults should have correct values', () {
        const options = InviteCodeOptions.defaults;

        expect(options.minLength, 6);
        expect(options.maxLength, 8);
        expect(options.maxAttempts, 10);
        expect(options.uppercaseOnly, true);
      });

      test('short option should have length 6', () {
        const options = InviteCodeOptions.short;

        expect(options.minLength, 6);
        expect(options.maxLength, 6);
      });

      test('long option should have length 8', () {
        const options = InviteCodeOptions.long;

        expect(options.minLength, 8);
        expect(options.maxLength, 8);
      });
    });

    group('InviteCodeResult', () {
      test('should have correct string representation', () {
        const result = InviteCodeResult(
          code: 'ABC12345',
          attemptsUsed: 1,
          codeLength: 8,
        );

        expect(
          result.toString(),
          'InviteCodeResult(code: ABC12345, attempts: 1, length: 8)',
        );
      });
    });
  });
}
