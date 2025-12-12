import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/stoycoins/models/donate_response.dart';
import 'package:stoyco_shared/stoycoins/models/donate_result.dart';

void main() {
  group('DonateResponse', () {
    test('fromJson parses nested DonateResultModel', () {
      final json = {
        'error': -1,
        'messageError': '',
        'tecMessageError': '',
        'count': -1,
        'data': {
          'transactionId': 'tx123',
          'newBalance': '100',
          'transactionState': 'success',
          'currentLevelName': 'Gold',
          'pointsToNextLevel': 50,
          'contextResult': {
            'projectId': 'p1',
            'communityOwnerId': 'c1',
            'contributedAmount': 10,
            'status': 'ok',
            'message': 'done',
          }
        }
      };
      final response = DonateResponse.fromJson(json);
      expect(response.error, -1);
      expect(response.data, isA<DonateResultModel>());
      expect(response.data?.transactionId, 'tx123');
      expect(response.data?.contextResult?.projectId, 'p1');
    });
  });
}

