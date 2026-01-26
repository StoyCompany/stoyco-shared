import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/stoy_shop/models/minted_nft_model.dart';
import 'package:stoyco_shared/stoy_shop/models/nft_metadata_model.dart';

void main() {
  group('MintedNftModel', () {
    test('fromJson creates model correctly', () {
      final json = {
        'id': '6973c0d02641d6e0d60c6138',
        'holderAddress': '0xba9Ebc409fB19EB1f0EF162E7952c70869170FA7',
        'collectionId': 367,
        'contractAddress': '0x594b8a9a9dB1274995070663191883499dD5BA56',
        'tokenId': 655,
        'txHash':
            '0xe2ae10334366627ab1bfc862373df20101005c5245d6f144c141ea1a9759defe',
        'metadataUri': 'https://qa.nft.stoyco.io/metadata/token/655',
        'imageUri': 'https://qa.nft.stoyco.io/image/token/655',
        'metadata': {
          'name': 'Mora AC:2',
          'description': 'Mora AC:2 activo cultural ambiente QA',
          'image': 'https://qa.nft.stoyco.io/image/token/655',
          'attributes': [
            {'trait_type': 'Artist', 'value': 'Mora'},
            {'trait_type': 'Symbol', 'value': 'Mora AC:2'},
          ],
        },
        'tags': ['Mora AC:2', 'Mora'],
        'burned': false,
        'isViewed': false,
        'mintSerial': '27/50',
        'tokenStandard': 'ERC-721',
        'createdAt': '2026-01-23T18:41:20.458Z',
        'updatedAt': '0001-01-01T00:00:00Z',
      };

      final model = MintedNftModel.fromJson(json);

      expect(model.id, '6973c0d02641d6e0d60c6138');
      expect(model.holderAddress, '0xba9Ebc409fB19EB1f0EF162E7952c70869170FA7');
      expect(model.collectionId, 367);
      expect(model.tokenId, 655);
      expect(model.mintSerial, '27/50');
      expect(model.tokenStandard, 'ERC-721');
      expect(model.burned, false);
      expect(model.isViewed, false);
      expect(model.tags?.length, 2);
      expect(model.metadata?.name, 'Mora AC:2');
      expect(model.metadata?.attributes?.length, 2);
    });

    test('toJson serializes correctly', () {
      final model = MintedNftModel(
        id: 'test123',
        holderAddress: '0x123',
        collectionId: 100,
        tokenId: 1,
        mintSerial: '1/10',
        tokenStandard: 'ERC-721',
      );

      final json = model.toJson();

      expect(json['id'], 'test123');
      expect(json['collectionId'], 100);
      expect(json['tokenId'], 1);
      expect(json['mintSerial'], '1/10');
      expect(json['tokenStandard'], 'ERC-721');
    });

    test('copyWith creates new instance with updated values', () {
      final original = MintedNftModel(
        id: 'original',
        tokenId: 100,
        isViewed: false,
      );

      final updated = original.copyWith(
        isViewed: true,
        tokenId: 200,
      );

      expect(updated.id, 'original');
      expect(updated.tokenId, 200);
      expect(updated.isViewed, true);
      expect(original.isViewed, false);
    });

    test('isErc721 returns true for ERC-721 token', () {
      final model = MintedNftModel(tokenStandard: 'ERC-721');
      expect(model.isErc721, true);
    });

    test('isActive returns true when not burned', () {
      final model = MintedNftModel(burned: false);
      expect(model.isActive, true);
    });

    test('isActive returns false when burned', () {
      final model = MintedNftModel(burned: true);
      expect(model.isActive, false);
    });

    test('mintNumber extracts correct number from mintSerial', () {
      final model = MintedNftModel(mintSerial: '27/50');
      expect(model.mintNumber, 27);
      expect(model.maxSupply, 50);
    });

    test('mintNumber returns null for invalid mintSerial', () {
      final model1 = MintedNftModel(mintSerial: null);
      expect(model1.mintNumber, null);
      expect(model1.maxSupply, null);

      final model2 = MintedNftModel(mintSerial: 'invalid');
      expect(model2.mintNumber, null);
    });
  });
}
