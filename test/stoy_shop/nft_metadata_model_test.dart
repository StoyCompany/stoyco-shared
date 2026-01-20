import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/stoy_shop/models/nft_metadata_model.dart';

void main() {
  group('NftMetadataModel', () {
    test('creates instance from JSON', () {
      final json = {
        'name': 'Mora AC:2',
        'description': 'Mora AC:2 activo cultural ambiente QA',
        'image': 'https://qa.nft.stoyco.io/image/collection/2ffa5b3170a8428eb3bb3d87f68a6829',
        'attributes': [
          {'trait_type': 'Artist', 'value': 'Mora'},
          {'trait_type': 'Symbol', 'value': 'Mora AC:2'},
          {'trait_type': 'Collection Type', 'value': 'NFT'},
          {'trait_type': 'Max Supply', 'value': '50'},
          {'trait_type': 'Mora', 'value': '2025'},
          {'trait_type': 'Collection ID', 'value': '367'},
        ],
      };

      final metadata = NftMetadataModel.fromJson(json);

      expect(metadata.name, 'Mora AC:2');
      expect(metadata.description, 'Mora AC:2 activo cultural ambiente QA');
      expect(metadata.image, 'https://qa.nft.stoyco.io/image/collection/2ffa5b3170a8428eb3bb3d87f68a6829');
      expect(metadata.attributes?.length, 6);
    });

    test('converts to JSON', () {
      const metadata = NftMetadataModel(
        name: 'Test NFT',
        description: 'Test description',
        image: 'https://example.com/image.jpg',
        attributes: [
          NftAttributeModel(traitType: 'Artist', value: 'Test Artist'),
        ],
      );

      final json = metadata.toJson();

      expect(json['name'], 'Test NFT');
      expect(json['description'], 'Test description');
      expect(json['image'], 'https://example.com/image.jpg');
      expect(json['attributes'], isNotNull);
      expect((json['attributes'] as List).length, 1);
    });

    test('handles null attributes', () {
      final json = {
        'name': 'Test',
        'description': 'Test description',
        'image': 'https://example.com/image.jpg',
      };

      final metadata = NftMetadataModel.fromJson(json);

      expect(metadata.attributes, isNull);
    });

    test('handles empty attributes', () {
      final json = {
        'name': 'Test',
        'description': 'Test description',
        'image': 'https://example.com/image.jpg',
        'attributes': [],
      };

      final metadata = NftMetadataModel.fromJson(json);

      expect(metadata.attributes, isEmpty);
    });

    test('getAttributeValue returns correct value', () {
      const metadata = NftMetadataModel(
        name: 'Test',
        description: 'Test description',
        image: 'https://example.com/image.jpg',
        attributes: [
          NftAttributeModel(traitType: 'Artist', value: 'Mora'),
          NftAttributeModel(traitType: 'Max Supply', value: '50'),
          NftAttributeModel(traitType: 'Collection ID', value: '367'),
        ],
      );

      expect(metadata.getAttributeValue('Artist'), 'Mora');
      expect(metadata.getAttributeValue('Max Supply'), '50');
      expect(metadata.getAttributeValue('Collection ID'), '367');
    });

    test('getAttributeValue returns null for non-existent trait', () {
      const metadata = NftMetadataModel(
        name: 'Test',
        description: 'Test description',
        image: 'https://example.com/image.jpg',
        attributes: [
          NftAttributeModel(traitType: 'Artist', value: 'Mora'),
        ],
      );

      expect(metadata.getAttributeValue('NonExistent'), isNull);
    });

    test('getAttributeValue returns null when attributes is null', () {
      const metadata = NftMetadataModel(
        name: 'Test',
        description: 'Test description',
        image: 'https://example.com/image.jpg',
        attributes: null,
      );

      expect(metadata.getAttributeValue('Artist'), isNull);
    });

    test('getAttributeValue is case-sensitive', () {
      const metadata = NftMetadataModel(
        name: 'Test',
        description: 'Test description',
        image: 'https://example.com/image.jpg',
        attributes: [
          NftAttributeModel(traitType: 'Artist', value: 'Mora'),
        ],
      );

      expect(metadata.getAttributeValue('Artist'), 'Mora');
      expect(metadata.getAttributeValue('artist'), isNull);
      expect(metadata.getAttributeValue('ARTIST'), isNull);
    });
  });

  group('NftAttributeModel', () {
    test('creates instance from JSON', () {
      final json = {'trait_type': 'Artist', 'value': 'Mora'};

      final attribute = NftAttributeModel.fromJson(json);

      expect(attribute.traitType, 'Artist');
      expect(attribute.value, 'Mora');
    });

    test('converts to JSON', () {
      const attribute = NftAttributeModel(
        traitType: 'Artist',
        value: 'Mora',
      );

      final json = attribute.toJson();

      expect(json['trait_type'], 'Artist');
      expect(json['value'], 'Mora');
    });

    test('handles numeric values', () {
      final json = {'trait_type': 'Max Supply', 'value': 50};

      final attribute = NftAttributeModel.fromJson(json);

      expect(attribute.traitType, 'Max Supply');
      expect(attribute.value, 50);
    });

    test('handles string numeric values', () {
      final json = {'trait_type': 'Collection ID', 'value': '367'};

      final attribute = NftAttributeModel.fromJson(json);

      expect(attribute.traitType, 'Collection ID');
      expect(attribute.value, '367');
    });
  });
}
