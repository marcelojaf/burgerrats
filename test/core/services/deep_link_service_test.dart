import 'package:flutter_test/flutter_test.dart';
import 'package:burgerrats/core/services/deep_link_service.dart';

void main() {
  group('DeepLinkService', () {
    late DeepLinkService service;

    setUp(() {
      service = DeepLinkService();
    });

    group('parseDeepLink', () {
      test('parses custom scheme league invite link', () {
        final uri = Uri.parse('burgerrats://league/abc123');
        final result = service.parseDeepLink(uri);

        expect(result.type, DeepLinkType.leagueInvite);
        expect(result.id, 'abc123');
        expect(result.rawUri, uri);
      });

      test('parses custom scheme checkin share link', () {
        final uri = Uri.parse('burgerrats://checkin/xyz789');
        final result = service.parseDeepLink(uri);

        expect(result.type, DeepLinkType.checkInShare);
        expect(result.id, 'xyz789');
        expect(result.rawUri, uri);
      });

      test('parses HTTPS league invite link', () {
        final uri = Uri.parse('https://burgerrats.app/league/abc123');
        final result = service.parseDeepLink(uri);

        expect(result.type, DeepLinkType.leagueInvite);
        expect(result.id, 'abc123');
        expect(result.rawUri, uri);
      });

      test('parses HTTPS checkin share link', () {
        final uri = Uri.parse('https://burgerrats.app/checkin/xyz789');
        final result = service.parseDeepLink(uri);

        expect(result.type, DeepLinkType.checkInShare);
        expect(result.id, 'xyz789');
        expect(result.rawUri, uri);
      });

      test('returns unknown for unsupported scheme', () {
        final uri = Uri.parse('http://example.com/some/path');
        final result = service.parseDeepLink(uri);

        expect(result.type, DeepLinkType.unknown);
        expect(result.id, isNull);
      });

      test('returns unknown for unsupported custom scheme path', () {
        final uri = Uri.parse('burgerrats://unknown/path');
        final result = service.parseDeepLink(uri);

        expect(result.type, DeepLinkType.unknown);
      });

      test('returns unknown for HTTPS with wrong host', () {
        final uri = Uri.parse('https://other.com/league/abc123');
        final result = service.parseDeepLink(uri);

        expect(result.type, DeepLinkType.unknown);
      });
    });

    group('generateLeagueInviteLink', () {
      test('generates correct custom scheme link', () {
        final link = service.generateLeagueInviteLink('league123');
        expect(link, 'burgerrats://league/league123');
      });

      test('handles special characters in ID', () {
        final link = service.generateLeagueInviteLink('league-with-dash');
        expect(link, 'burgerrats://league/league-with-dash');
      });
    });

    group('generateCheckInShareLink', () {
      test('generates correct custom scheme link', () {
        final link = service.generateCheckInShareLink('checkin456');
        expect(link, 'burgerrats://checkin/checkin456');
      });
    });

    group('generateLeagueInviteWebLink', () {
      test('generates correct HTTPS link', () {
        final link = service.generateLeagueInviteWebLink('league123');
        expect(link, 'https://burgerrats.app/league/league123');
      });
    });

    group('generateCheckInShareWebLink', () {
      test('generates correct HTTPS link', () {
        final link = service.generateCheckInShareWebLink('checkin456');
        expect(link, 'https://burgerrats.app/checkin/checkin456');
      });
    });

    group('DeepLinkData', () {
      test('toString includes all fields', () {
        final data = DeepLinkData(
          type: DeepLinkType.leagueInvite,
          id: 'test123',
          rawUri: Uri.parse('burgerrats://league/test123'),
        );

        final result = data.toString();
        expect(result, contains('leagueInvite'));
        expect(result, contains('test123'));
      });
    });
  });
}
