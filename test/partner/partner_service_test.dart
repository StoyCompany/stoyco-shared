import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/partner/partner_service.dart';

/// Integration tests for PartnerService
///
/// These tests verify the service behavior with real data sources.
/// For unit tests with mocked dependencies, see partner_repository_test.dart
void main() {
  tearDown(() {
    PartnerService.resetInstance();
  });

  group('PartnerService singleton', () {
    test('should return same instance on multiple calls', () {
      final instance1 = PartnerService(environment: StoycoEnvironment.testing);
      final instance2 = PartnerService(environment: StoycoEnvironment.testing);

      expect(instance1, same(instance2));
    });

    test('should reset instance correctly', () {
      final instance1 = PartnerService(environment: StoycoEnvironment.testing);
      PartnerService.resetInstance();
      final instance2 = PartnerService(environment: StoycoEnvironment.testing);

      expect(instance1, isNot(same(instance2)));
    });

    test('should provide access to singleton instance', () {
      PartnerService(environment: StoycoEnvironment.testing);

      expect(PartnerService.instance, isNotNull);
      expect(PartnerService.instance, isA<PartnerService>());
    });
  });

  group('PartnerService getPartnerCommunityById', () {
    test(
        'should attempt to fetch partner community data (may be Left on network)',
        () async {
      final service = PartnerService(environment: StoycoEnvironment.testing);
      final partnerId = '690bd75ed53b645941ae9f7c';

      final result = await service.getPartnerCommunityById(partnerId);

      // Accept Left if remote not reachable in test environment; only validate structure on Right.
      if (result.isRight) {
        final response = result.right;
        expect(response.partner.id, equals(partnerId));
        expect(response.partner.name, isNotEmpty);
        expect(response.community.id, isNotEmpty);
      }
    });

    test('should handle different partner IDs (result may be Left)', () async {
      final service = PartnerService(environment: StoycoEnvironment.testing);
      final partnerId = 'test-partner-id-123';

      final result = await service.getPartnerCommunityById(partnerId);

      // Either is acceptable; on Right just assert basic structure.
      if (result.isRight) {
        expect(result.right.partner.id, isNotEmpty);
      }
    });
  });

  group('PartnerService getMarketSegments', () {
    test('should return list of market segments successfully', () async {
      final service = PartnerService(environment: StoycoEnvironment.testing);

      final result = await service.getMarketSegments();

      expect(result.isRight, true);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (segments) {
          expect(segments, isNotNull);
          expect(segments, isA<List>());
          // Should return at least one segment
          expect(segments.isNotEmpty, true);

          // Verify segment structure
          final firstSegment = segments.first;
          expect(firstSegment.id, isNotEmpty);
          expect(firstSegment.name, isNotEmpty);
        },
      );
    });

    test('should return segments with valid data structure', () async {
      final service = PartnerService(environment: StoycoEnvironment.testing);

      final result = await service.getMarketSegments();

      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (segments) {
          for (final segment in segments) {
            expect(segment.id, isNotNull);
            expect(segment.name, isNotNull);
            expect(segment.id.isNotEmpty, true);
            expect(segment.name.isNotEmpty, true);
          }
        },
      );
    });
  });

  group('PartnerService checkPartnerFollow', () {
    test('should return follow check response successfully when following',
        () async {
      final service = PartnerService(environment: StoycoEnvironment.testing);

      final result = await service.checkPartnerFollow(
        userId: 'user123',
        partnerId: 'partner456',
      );

      expect(result.isRight, true);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (response) {
          expect(response, isNotNull);
          expect(response.error, -1);
          expect(response.messageError, '');
          expect(response.tecMessageError, '');
          expect(response.count, -1);
          expect(response.data, isA<bool>());
          expect(response.isFollowing, isA<bool>());
        },
      );
    });

    test('should handle different user and partner combinations', () async {
      final service = PartnerService(environment: StoycoEnvironment.testing);

      final result1 = await service.checkPartnerFollow(
        userId: 'user789',
        partnerId: 'partner123',
      );

      final result2 = await service.checkPartnerFollow(
        userId: 'differentUser',
        partnerId: 'differentPartner',
      );

      expect(result1.isRight, true);
      expect(result2.isRight, true);
    });

    test('should validate response structure for follow check', () async {
      final service = PartnerService(environment: StoycoEnvironment.testing);

      final result = await service.checkPartnerFollow(
        userId: 'validUser',
        partnerId: 'validPartner',
      );

      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (response) {
          // Validate all required fields are present
          expect(response.error, isNotNull);
          expect(response.messageError, isNotNull);
          expect(response.tecMessageError, isNotNull);
          expect(response.count, isNotNull);
          expect(response.data, isNotNull);
          expect(response.isFollowing, isNotNull);
        },
      );
    });
  });

  group('PartnerService error handling', () {
    test('should handle service initialization with different environments',
        () {
      final devService =
          PartnerService(environment: StoycoEnvironment.development);
      PartnerService.resetInstance();

      final testService =
          PartnerService(environment: StoycoEnvironment.testing);
      PartnerService.resetInstance();

      final prodService =
          PartnerService(environment: StoycoEnvironment.production);

      expect(devService, isNotNull);
      expect(testService, isNotNull);
      expect(prodService, isNotNull);
    });
  });

  group('PartnerService getPartnerContentAvailability', () {
    test('should return content availability successfully', () async {
      final service = PartnerService(environment: StoycoEnvironment.testing);
      final partnerId = '66f5bd918d77fca522545f01';

      final result = await service.getPartnerContentAvailability(partnerId);
      expect(result.isRight, true);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (availability) {
          expect(availability.data.partnerId, partnerId);
          // Booleans may vary depending on test environment; assert structure
          expect(availability.data.nfts, isA<bool>());
          expect(availability.data.videos, isA<bool>());
          expect(availability.data.products, isA<bool>());
        },
      );
    });
  });
}
