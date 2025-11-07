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
    test('should return partner community data successfully', () async {
      final service = PartnerService(environment: StoycoEnvironment.testing);
      final partnerId = '690bd75ed53b645941ae9f7c';

      final result = await service.getPartnerCommunityById(partnerId);

      expect(result.isRight, true);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (response) {
          expect(response, isNotNull);
          expect(response.partner, isNotNull);
          expect(response.partner.id, equals(partnerId));
          expect(response.partner.name, isNotEmpty);
          expect(response.community, isNotNull);
          expect(response.community.id, isNotEmpty);
        },
      );
    });

    test('should handle different partner IDs', () async {
      final service = PartnerService(environment: StoycoEnvironment.testing);
      final partnerId = 'test-partner-id-123';

      final result = await service.getPartnerCommunityById(partnerId);

      // Should return data regardless of ID (mock data scenario)
      expect(result.isRight, true);
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
}
