import 'package:flutter_test/flutter_test.dart';
import 'package:burgerrats/shared/utils/validators.dart';
import 'package:burgerrats/core/errors/error_messages.dart';

void main() {
  group('Validators', () {
    group('email', () {
      test('should return error for empty email', () {
        expect(Validators.email(''), ErrorMessages.requiredField);
        expect(Validators.email(null), ErrorMessages.requiredField);
      });

      test('should return error for invalid email format', () {
        expect(Validators.email('invalid'), ErrorMessages.invalidEmail);
        expect(Validators.email('invalid@'), ErrorMessages.invalidEmail);
        expect(Validators.email('@test.com'), ErrorMessages.invalidEmail);
        expect(Validators.email('test@.com'), ErrorMessages.invalidEmail);
      });

      test('should return null for valid email', () {
        expect(Validators.email('test@example.com'), isNull);
        expect(Validators.email('user.name@domain.co'), isNull);
        expect(Validators.email('user+tag@example.org'), isNull);
        expect(Validators.email('  test@example.com  '), isNull);
      });
    });

    group('password', () {
      test('should return error for empty password', () {
        expect(Validators.password(''), ErrorMessages.requiredField);
        expect(Validators.password(null), ErrorMessages.requiredField);
      });

      test('should return error for password less than 6 characters', () {
        expect(Validators.password('12345'), ErrorMessages.weakPassword);
        expect(Validators.password('abc'), ErrorMessages.weakPassword);
      });

      test('should return null for valid password', () {
        expect(Validators.password('123456'), isNull);
        expect(Validators.password('password'), isNull);
        expect(Validators.password('longpassword123!'), isNull);
      });
    });

    group('confirmPassword', () {
      test('should return error for empty confirmation', () {
        expect(
          Validators.confirmPassword('', 'password'),
          ErrorMessages.requiredField,
        );
        expect(
          Validators.confirmPassword(null, 'password'),
          ErrorMessages.requiredField,
        );
      });

      test('should return error when passwords do not match', () {
        expect(
          Validators.confirmPassword('password1', 'password2'),
          ErrorMessages.passwordMismatch,
        );
      });

      test('should return null when passwords match', () {
        expect(
          Validators.confirmPassword('password', 'password'),
          isNull,
        );
        expect(
          Validators.confirmPassword('123456', '123456'),
          isNull,
        );
      });
    });

    group('required', () {
      test('should return error for empty value', () {
        expect(Validators.required(''), ErrorMessages.requiredField);
        expect(Validators.required(null), ErrorMessages.requiredField);
        expect(Validators.required('   '), ErrorMessages.requiredField);
      });

      test('should return null for non-empty value', () {
        expect(Validators.required('value'), isNull);
        expect(Validators.required('  value  '), isNull);
      });
    });

    group('displayName', () {
      test('should return error for empty name', () {
        expect(Validators.displayName(''), ErrorMessages.requiredField);
        expect(Validators.displayName(null), ErrorMessages.requiredField);
        expect(Validators.displayName('   '), ErrorMessages.requiredField);
      });

      test('should return error for name exceeding 50 characters', () {
        final longName = 'a' * 51;
        expect(Validators.displayName(longName), ErrorMessages.maxLength);
      });

      test('should return null for valid name', () {
        expect(Validators.displayName('John'), isNull);
        expect(Validators.displayName('John Doe'), isNull);
        expect(Validators.displayName('a' * 50), isNull);
      });
    });
  });
}
