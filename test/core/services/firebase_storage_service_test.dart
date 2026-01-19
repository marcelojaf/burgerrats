import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:burgerrats/core/services/firebase_storage_service.dart';
import 'package:burgerrats/core/errors/exceptions.dart';

// Mock classes
class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockReference extends Mock implements Reference {}

class MockUploadTask extends Mock implements UploadTask {}

class MockTaskSnapshot extends Mock implements TaskSnapshot {}

class MockFullMetadata extends Mock implements FullMetadata {}

class MockListResult extends Mock implements ListResult {}

class FakeFile extends Fake implements File {
  final String _path;
  final int _size;
  final bool _exists;

  FakeFile({
    required String path,
    int size = 1024,
    bool exists = true,
  })  : _path = path,
        _size = size,
        _exists = exists;

  @override
  String get path => _path;

  @override
  Future<bool> exists() async => _exists;

  @override
  Future<int> length() async => _size;
}

void main() {
  late FirebaseStorageService service;
  late MockFirebaseStorage mockStorage;
  late MockReference mockRef;
  late MockUploadTask mockUploadTask;

  setUp(() {
    mockStorage = MockFirebaseStorage();
    mockRef = MockReference();
    mockUploadTask = MockUploadTask();
    service = FirebaseStorageService(mockStorage);

    // Default stubs
    when(() => mockStorage.ref()).thenReturn(mockRef);
    when(() => mockRef.child(any())).thenReturn(mockRef);
  });

  setUpAll(() {
    registerFallbackValue(SettableMetadata());
    registerFallbackValue(FakeFile(path: '/fake/path.jpg'));
  });

  group('FirebaseStorageService', () {
    group('UploadResult', () {
      test('creates with required fields', () {
        final result = UploadResult(
          downloadUrl: 'https://example.com/file.jpg',
          storagePath: 'check-ins/user1/2024/01/15/photo.jpg',
          fileName: 'photo.jpg',
          sizeInBytes: 1024,
          uploadedAt: DateTime(2024, 1, 15),
        );

        expect(result.downloadUrl, 'https://example.com/file.jpg');
        expect(result.storagePath, 'check-ins/user1/2024/01/15/photo.jpg');
        expect(result.fileName, 'photo.jpg');
        expect(result.sizeInBytes, 1024);
        expect(result.contentType, isNull);
        expect(result.metadata, isNull);
      });

      test('creates with all fields', () {
        final result = UploadResult(
          downloadUrl: 'https://example.com/file.jpg',
          storagePath: 'check-ins/user1/2024/01/15/photo.jpg',
          fileName: 'photo.jpg',
          sizeInBytes: 2048,
          contentType: 'image/jpeg',
          uploadedAt: DateTime(2024, 1, 15),
          metadata: {'userId': 'user1'},
        );

        expect(result.contentType, 'image/jpeg');
        expect(result.metadata, {'userId': 'user1'});
      });

      test('toString includes key information', () {
        final result = UploadResult(
          downloadUrl: 'https://example.com/file.jpg',
          storagePath: 'path/to/file.jpg',
          fileName: 'file.jpg',
          sizeInBytes: 1024,
          uploadedAt: DateTime.now(),
        );

        final str = result.toString();
        expect(str, contains('file.jpg'));
        expect(str, contains('1024'));
        expect(str, contains('https://example.com/file.jpg'));
      });
    });

    group('UploadOptions', () {
      test('creates with defaults', () {
        const options = UploadOptions();

        expect(options.metadata, isNull);
        expect(options.contentType, isNull);
        expect(options.useTimestampFilename, isTrue);
        expect(options.customFileName, isNull);
        expect(options.cacheControl, isNull);
      });

      test('checkInPhoto preset has correct values', () {
        const options = UploadOptions.checkInPhoto;

        expect(options.useTimestampFilename, isTrue);
        expect(options.cacheControl, 'public, max-age=31536000');
      });

      test('profilePhoto preset has correct values', () {
        const options = UploadOptions.profilePhoto;

        expect(options.useTimestampFilename, isTrue);
        expect(options.cacheControl, 'public, max-age=86400');
      });

      test('temporary preset has correct values', () {
        const options = UploadOptions.temporary;

        expect(options.useTimestampFilename, isTrue);
        expect(options.cacheControl, 'no-cache');
      });

      test('copyWith preserves values', () {
        const options = UploadOptions(
          metadata: {'key': 'value'},
          contentType: 'image/png',
          useTimestampFilename: false,
        );

        final copied = options.copyWith(contentType: 'image/jpeg');

        expect(copied.metadata, {'key': 'value'});
        expect(copied.contentType, 'image/jpeg');
        expect(copied.useTimestampFilename, isFalse);
      });

      test('copyWith overrides values', () {
        const options = UploadOptions.checkInPhoto;

        final copied = options.copyWith(
          metadata: {'newKey': 'newValue'},
          cacheControl: 'no-store',
        );

        expect(copied.metadata, {'newKey': 'newValue'});
        expect(copied.cacheControl, 'no-store');
        expect(copied.useTimestampFilename, isTrue);
      });
    });

    group('constants', () {
      test('maxFileSizeBytes is 10MB', () {
        expect(FirebaseStorageService.maxFileSizeBytes, 10 * 1024 * 1024);
      });

      test('allowedImageTypes contains expected types', () {
        expect(
          FirebaseStorageService.allowedImageTypes,
          containsAll([
            'image/jpeg',
            'image/jpg',
            'image/png',
            'image/webp',
            'image/heic',
            'image/heif',
          ]),
        );
      });
    });

    group('getDownloadUrl', () {
      test('returns download URL successfully', () async {
        const path = 'check-ins/user1/2024/01/15/photo.jpg';
        const expectedUrl = 'https://storage.googleapis.com/bucket/photo.jpg';

        when(() => mockRef.getDownloadURL()).thenAnswer((_) async => expectedUrl);

        final url = await service.getDownloadUrl(path);

        expect(url, expectedUrl);
        verify(() => mockStorage.ref()).called(1);
        verify(() => mockRef.child(path)).called(1);
        verify(() => mockRef.getDownloadURL()).called(1);
      });

      test('throws StorageException on FirebaseException', () async {
        const path = 'nonexistent/path.jpg';

        when(() => mockRef.getDownloadURL()).thenThrow(
          FirebaseException(
            plugin: 'storage',
            code: 'storage/object-not-found',
            message: 'Object not found',
          ),
        );

        expect(
          () => service.getDownloadUrl(path),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('deleteFile', () {
      test('deletes file successfully', () async {
        const path = 'check-ins/user1/2024/01/15/photo.jpg';

        when(() => mockRef.delete()).thenAnswer((_) async {});

        await service.deleteFile(path);

        verify(() => mockStorage.ref()).called(1);
        verify(() => mockRef.child(path)).called(1);
        verify(() => mockRef.delete()).called(1);
      });

      test('throws StorageException on FirebaseException', () async {
        const path = 'nonexistent/path.jpg';

        when(() => mockRef.delete()).thenThrow(
          FirebaseException(
            plugin: 'storage',
            code: 'storage/object-not-found',
            message: 'Object not found',
          ),
        );

        expect(
          () => service.deleteFile(path),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('getFileMetadata', () {
      test('returns metadata successfully', () async {
        const path = 'check-ins/user1/2024/01/15/photo.jpg';
        final mockMetadata = MockFullMetadata();

        when(() => mockRef.getMetadata()).thenAnswer((_) async => mockMetadata);

        final metadata = await service.getFileMetadata(path);

        expect(metadata, mockMetadata);
        verify(() => mockStorage.ref()).called(1);
        verify(() => mockRef.child(path)).called(1);
        verify(() => mockRef.getMetadata()).called(1);
      });

      test('throws StorageException on FirebaseException', () async {
        const path = 'nonexistent/path.jpg';

        when(() => mockRef.getMetadata()).thenThrow(
          FirebaseException(
            plugin: 'storage',
            code: 'storage/object-not-found',
            message: 'Object not found',
          ),
        );

        expect(
          () => service.getFileMetadata(path),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('listCheckInPhotos', () {
      test('returns list of paths for user on date', () async {
        const userId = 'user123';
        final date = DateTime(2024, 1, 15);
        final mockListResult = MockListResult();
        final mockItem1 = MockReference();
        final mockItem2 = MockReference();

        when(() => mockItem1.fullPath)
            .thenReturn('check-ins/user123/2024/01/15/photo1.jpg');
        when(() => mockItem2.fullPath)
            .thenReturn('check-ins/user123/2024/01/15/photo2.jpg');
        when(() => mockListResult.items).thenReturn([mockItem1, mockItem2]);
        when(() => mockRef.listAll()).thenAnswer((_) async => mockListResult);

        final paths = await service.listCheckInPhotos(
          userId: userId,
          date: date,
        );

        expect(paths.length, 2);
        expect(paths[0], 'check-ins/user123/2024/01/15/photo1.jpg');
        expect(paths[1], 'check-ins/user123/2024/01/15/photo2.jpg');

        verify(() => mockRef.child('check-ins/user123/2024/01/15/')).called(1);
        verify(() => mockRef.listAll()).called(1);
      });

      test('returns empty list when no photos exist', () async {
        const userId = 'user123';
        final date = DateTime(2024, 1, 15);
        final mockListResult = MockListResult();

        when(() => mockListResult.items).thenReturn([]);
        when(() => mockRef.listAll()).thenAnswer((_) async => mockListResult);

        final paths = await service.listCheckInPhotos(
          userId: userId,
          date: date,
        );

        expect(paths, isEmpty);
      });

      test('throws StorageException on FirebaseException', () async {
        const userId = 'user123';
        final date = DateTime(2024, 1, 15);

        when(() => mockRef.listAll()).thenThrow(
          FirebaseException(
            plugin: 'storage',
            code: 'storage/unauthorized',
            message: 'Unauthorized',
          ),
        );

        expect(
          () => service.listCheckInPhotos(userId: userId, date: date),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('path generation', () {
      test('generates correct path for check-in photo', () async {
        // Test via listCheckInPhotos which uses same path logic
        const userId = 'testUser';
        final date = DateTime(2024, 3, 5); // March 5th

        final mockListResult = MockListResult();
        when(() => mockListResult.items).thenReturn([]);
        when(() => mockRef.listAll()).thenAnswer((_) async => mockListResult);

        await service.listCheckInPhotos(userId: userId, date: date);

        // Verify the path includes padded month and day
        verify(() => mockRef.child('check-ins/testUser/2024/03/05/')).called(1);
      });
    });
  });
}
