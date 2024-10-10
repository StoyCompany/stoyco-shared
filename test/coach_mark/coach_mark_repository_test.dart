import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:dio/dio.dart';
import 'package:stoyco_shared/coach_mark/coach_mark_data_source.dart';
import 'package:stoyco_shared/coach_mark/coach_mark_repository.dart';

import 'coach_mark_repository_test.mocks.dart';

@GenerateMocks([CoachMarkDataSource])
void main() {
  late CoachMarkRepository repository;
  late MockCoachMarkDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockCoachMarkDataSource();
    repository = CoachMarkRepository(mockDataSource, 'testToken');
  });

  group('GetOnboardingsByUserCoachMarkData Group', () {
    test('getOnboardingsByUserCoachMarkData should return a list of Onboarding',
        () async {
      final response = Response(
        data: {
          'data': [
            {
              'id': 'id',
              'userId': 'userId',
              'type': 'home',
              'step': 1,
              'isCompleted': true,
              'createdAt': '2021-10-01T00:00:00.000Z',
              'updatedAt': '2021-10-01T00:00:00.000Z',
            }
          ],
        },
        statusCode: 200,
        requestOptions: RequestOptions(
          path: 'https://dev.api.stoyco.io/api/stoyco/v1/onboarding/user',
        ),
      );

      when(mockDataSource.getOnboardingsByUserCoachMarkData())
          .thenAnswer((_) async => response);

      final result = await repository.getOnboardingsByUserCoachMarkData();

      expect(result.isRight, true);
      expect(result.fold((l) => null, (r) => r.length), 1);
    });

    test(
        'getOnboardingsByUserCoachMarkData should return a DioFailure when DioException is thrown',
        () async {
      when(mockDataSource.getOnboardingsByUserCoachMarkData()).thenThrow(
        DioException(
          response: Response(
            requestOptions: RequestOptions(
              path: 'https://dev.api.stoyco.io/api/stoyco/v1/onboarding/user',
            ),
          ),
          requestOptions: RequestOptions(
            path: 'https://dev.api.stoyco.io/api/stoyco/v1/onboarding/user',
          ),
        ),
      );

      final result = await repository.getOnboardingsByUserCoachMarkData();

      expect(result.isLeft, true);
    });

    test(
        'getOnboardingsByUserCoachMarkData should return a ErrorFailure when Error is thrown',
        () async {
      when(mockDataSource.getOnboardingsByUserCoachMarkData()).thenThrow(
        Error(),
      );

      final result = await repository.getOnboardingsByUserCoachMarkData();

      expect(result.isLeft, true);
    });

    test(
        'getOnboardingsByUserCoachMarkData should return a ExceptionFailure when Exception is thrown',
        () async {
      when(mockDataSource.getOnboardingsByUserCoachMarkData()).thenThrow(
        Exception(),
      );

      final result = await repository.getOnboardingsByUserCoachMarkData();

      expect(result.isLeft, true);
    });
  });

  group('GetOnboardingByTypeCoachMarkData Group', () {
    final requestOptions = RequestOptions(
      path: 'https://dev.api.stoyco.io/api/stoyco/v1/onboarding/home',
    );
    test('getOnboardingByTypeCoachMarkData should return a Onboarding',
        () async {
      final response = Response(
        data: {
          'data': {
            'id': 'id',
            'userId': 'userId',
            'type': 'home',
            'step': 1,
            'isCompleted': true,
            'createdAt': '2021-10-01T00:00:00.000Z',
            'updatedAt': '2021-10-01T00:00:00.000Z',
          },
        },
        statusCode: 200,
        requestOptions: requestOptions,
      );

      when(mockDataSource.getOnboardingByTypeCoachMarkData(type: 'home'))
          .thenAnswer((_) async => response);

      final result = await repository.getOnboardingByTypeCoachMarkData(
        type: 'home',
      );

      expect(result.isRight, true);
      expect(result.fold((l) => null, (r) => r.id), 'id');
    });

    test(
        'getOnboardingByTypeCoachMarkData should return a DioFailure when DioException is thrown',
        () async {
      when(mockDataSource.getOnboardingByTypeCoachMarkData(type: 'home'))
          .thenThrow(
        DioException(
          response: Response(
            requestOptions: requestOptions,
          ),
          requestOptions: requestOptions,
        ),
      );

      final result = await repository.getOnboardingByTypeCoachMarkData(
        type: 'home',
      );

      expect(result.isLeft, true);
    });

    test(
        'getOnboardingByTypeCoachMarkData should return a ErrorFailure when Error is thrown',
        () async {
      when(mockDataSource.getOnboardingByTypeCoachMarkData(type: 'home'))
          .thenThrow(Error());

      final result = await repository.getOnboardingByTypeCoachMarkData(
        type: 'home',
      );

      expect(result.isLeft, true);
    });

    test(
        'getOnboardingByTypeCoachMarkData should return a ExceptionFailure when Exception is thrown',
        () async {
      when(mockDataSource.getOnboardingByTypeCoachMarkData(type: 'home'))
          .thenThrow(Exception());

      final result = await repository.getOnboardingByTypeCoachMarkData(
        type: 'home',
      );

      expect(result.isLeft, true);
    });
  });

  group('UpdateOnboardingCoachMarkData Group', () {
    final requestOptions = RequestOptions(
      path: 'https://dev.api.stoyco.io/api/stoyco/v1/onboarding/home',
    );

    test('updateOnboardingCoachMarkData should return a Onboarding', () async {
      final response = Response(
        data: {
          'data': {
            'id': 'id',
            'userId': 'userId',
            'type': 'home',
            'step': 1,
            'isCompleted': true,
            'createdAt': '2021-10-01T00:00:00.000Z',
            'updatedAt': '2021-10-01T00:00:00.000Z',
          },
        },
        statusCode: 200,
        requestOptions: requestOptions,
      );

      when(
        mockDataSource.updateOnboardingCoachMarkData(
          type: 'home',
          step: 1,
          isCompleted: true,
        ),
      ).thenAnswer((_) async => response);

      final result = await repository.updateOnboardingCoachMarkData(
        type: 'home',
        step: 1,
        isCompleted: true,
      );

      expect(result.isRight, true);
      expect(result.fold((l) => null, (r) => r.id), 'id');
    });

    test(
        'updateOnboardingCoachMarkData should return a DioFailure when DioException is thrown',
        () async {
      when(
        mockDataSource.updateOnboardingCoachMarkData(
          type: 'home',
          step: 1,
          isCompleted: true,
        ),
      ).thenThrow(
        DioException(
          response: Response(
            requestOptions: requestOptions,
          ),
          requestOptions: requestOptions,
        ),
      );

      final result = await repository.updateOnboardingCoachMarkData(
        type: 'home',
        step: 1,
        isCompleted: true,
      );

      expect(result.isLeft, true);
    });

    test(
        'updateOnboardingCoachMarkData should return a ErrorFailure when Error is thrown',
        () async {
      when(
        mockDataSource.updateOnboardingCoachMarkData(
          type: 'home',
          step: 1,
          isCompleted: true,
        ),
      ).thenThrow(Error());

      final result = await repository.updateOnboardingCoachMarkData(
        type: 'home',
        step: 1,
        isCompleted: true,
      );

      expect(result.isLeft, true);
    });

    test(
        'updateOnboardingCoachMarkData should return a ExceptionFailure when Exception is thrown',
        () async {
      when(
        mockDataSource.updateOnboardingCoachMarkData(
          type: 'home',
          step: 1,
          isCompleted: true,
        ),
      ).thenThrow(Exception());

      final result = await repository.updateOnboardingCoachMarkData(
        type: 'home',
        step: 1,
        isCompleted: true,
      );

      expect(result.isLeft, true);
    });
  });

  group('CreateOnboardingCoachMarkData Group', () {
    final requestOptions = RequestOptions(
      path: 'https://dev.api.stoyco.io/api/stoyco/v1/onboarding/home',
    );

    test('createOnboardingCoachMarkData should return a Onboarding', () async {
      final response = Response(
        data: {
          'data': {
            'id': 'id',
            'userId': 'userId',
            'type': 'home',
            'step': 1,
            'isCompleted': true,
            'createdAt': '2021-10-01T00:00:00.000Z',
            'updatedAt': '2021-10-01T00:00:00.000Z',
          },
        },
        statusCode: 200,
        requestOptions: requestOptions,
      );

      when(
        mockDataSource.createOnboardingCoachMarkData(
          type: 'home',
        ),
      ).thenAnswer((_) async => response);

      final result = await repository.createOnboardingCoachMarkData(
        type: 'home',
      );

      expect(result.isRight, true);
      expect(result.fold((l) => null, (r) => r.id), 'id');
    });

    test(
        'createOnboardingCoachMarkData should return a DioFailure when DioException is thrown',
        () async {
      when(
        mockDataSource.createOnboardingCoachMarkData(
          type: 'home',
        ),
      ).thenThrow(
        DioException(
          response: Response(
            requestOptions: requestOptions,
          ),
          requestOptions: requestOptions,
        ),
      );

      final result = await repository.createOnboardingCoachMarkData(
        type: 'home',
      );

      expect(result.isLeft, true);
    });

    test(
        'createOnboardingCoachMarkData should return a ErrorFailure when Error is thrown',
        () async {
      when(
        mockDataSource.createOnboardingCoachMarkData(
          type: 'home',
        ),
      ).thenThrow(Error());

      final result = await repository.createOnboardingCoachMarkData(
        type: 'home',
      );

      expect(result.isLeft, true);
    });

    test(
        'createOnboardingCoachMarkData should return a ExceptionFailure when Exception is thrown',
        () async {
      when(
        mockDataSource.createOnboardingCoachMarkData(
          type: 'home',
        ),
      ).thenThrow(Exception());

      final result = await repository.createOnboardingCoachMarkData(
        type: 'home',
      );

      expect(result.isLeft, true);
    });
  });

  group('ResetOnboardingCoachMarkData Group', () {
    final requestOptions = RequestOptions(
      path: 'https://dev.api.stoyco.io/api/stoyco/v1/onboarding/home',
    );

    test('resetOnboardingCoachMarkData should return a bool', () async {
      final response = Response(
        data: {
          'data': {
            'id': 'id',
            'userId': 'userId',
            'type': 'home',
            'step': 1,
            'isCompleted': true,
            'createdAt': '2021-10-01T00:00:00.000Z',
            'updatedAt': '2021-10-01T00:00:00.000Z',
          },
        },
        statusCode: 200,
        requestOptions: requestOptions,
      );

      when(mockDataSource.resetOnboardingCoachMarkData())
          .thenAnswer((_) async => response);

      final result = await repository.resetOnboardingCoachMarkData();

      expect(result.isRight, true);
      expect(result.fold((l) => null, (r) => r), true);
    });

    test(
        'resetOnboardingCoachMarkData should return a DioFailure when DioException is thrown',
        () async {
      when(mockDataSource.resetOnboardingCoachMarkData()).thenThrow(
        DioException(
          response: Response(
            requestOptions: requestOptions,
          ),
          requestOptions: requestOptions,
        ),
      );

      final result = await repository.resetOnboardingCoachMarkData();

      expect(result.isLeft, true);
    });

    test(
        'resetOnboardingCoachMarkData should return a ErrorFailure when Error is thrown',
        () async {
      when(mockDataSource.resetOnboardingCoachMarkData()).thenThrow(Error());

      final result = await repository.resetOnboardingCoachMarkData();

      expect(result.isLeft, true);
    });

    test(
        'resetOnboardingCoachMarkData should return a ExceptionFailure when Exception is thrown',
        () async {
      when(mockDataSource.resetOnboardingCoachMarkData())
          .thenThrow(Exception());

      final result = await repository.resetOnboardingCoachMarkData();

      expect(result.isLeft, true);
    });
  });

  //getCoachMarkData

  group('GetCoachMarkData Group', () {
    final requestOptions = RequestOptions(
      path:
          'https://stoyco-medias-dev.s3.amazonaws.com/data/coach_mark_data.json',
    );
    final data = {
      'coachMarks': [
        {
          'type': 'home',
          'initializationModal': {
            'title': '¡Bienvenido a StoyCo!',
            'description':
                'Descubre y co-crea experiencias únicas con tus artistas y marcas favoritas.',
            'button': '¿Como funciona?',
            'type': 'MODAL',
          },
          'finalizationModal': {
            'title': '¡Listo!',
            'description':
                '¡Ya estás listo para disfrutar de StoyCo! Explora, vota y gana StoyCoins.',
            'button': '¡Vamos!',
            'type': 'MODAL',
          },
          'content': [
            {
              'title': 'Descubre y Conéctate',
              'description':
                  'Explora artistas, partners, sus experiencias y el merch único que hemos preparado para ti.',
              'type': 'DIALOG',
              'enableClose': true,
              'enableNext': true,
              'step': 1,
            },
            {
              'title': '¡Participa!',
              'description':
                  'Vota y colabora en iniciativas dentro de tus comunidades favoritas.',
              'type': 'DIALOG',
              'enableClose': true,
              'enableNext': true,
              'step': 2,
            },
            {
              'title': 'Tu Wallet StoyCo',
              'description':
                  'Interactúa, gana StoyCoins y colecciona tus activos digitales.  Sube de nivel y desbloquea beneficios exclusivos.',
              'type': 'DIALOG',
              'enableClose': true,
              'enableNext': true,
              'step': 3,
            },
            {
              'title': 'Mantente informado',
              'description':
                  'Recibe alertas de tus comunidades, gana StoyCoins y accede a beneficios exclusivos.',
              'type': 'DIALOG',
              'enableNext': true,
              'step': 4,
            }
          ],
        }
      ],
    };

    test('getCoachMarkData should return a CoachMarkData', () async {
      final response =
          Response(data: data, statusCode: 200, requestOptions: requestOptions);

      when(mockDataSource.getCoachMarkData()).thenAnswer((_) async => response);

      final result = await repository.getCoachMarkData();

      expect(result.isRight, true);
      expect(result.fold((l) => null, (r) => (r.coachMarks?.length ?? 0)), 1);
    });

    test(
        'getCoachMarkData should return a DioFailure when DioException is thrown',
        () async {
      when(mockDataSource.getCoachMarkData()).thenThrow(
        DioException(
          response: Response(
            requestOptions: requestOptions,
          ),
          requestOptions: requestOptions,
        ),
      );

      final result = await repository.getCoachMarkData();

      expect(result.isLeft, true);
    });

    test('getCoachMarkData should return a ErrorFailure when Error is thrown',
        () async {
      when(mockDataSource.getCoachMarkData()).thenThrow(Error());

      final result = await repository.getCoachMarkData();

      expect(result.isLeft, true);
    });

    test(
        'getCoachMarkData should return a ExceptionFailure when Exception is thrown',
        () async {
      when(mockDataSource.getCoachMarkData()).thenThrow(Exception());

      final result = await repository.getCoachMarkData();

      expect(result.isLeft, true);
    });
  });
}
