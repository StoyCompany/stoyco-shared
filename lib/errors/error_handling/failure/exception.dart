import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/stoyco_shared.dart';

class ExceptionFailure extends Failure {
  factory ExceptionFailure.decode(Exception? error) {
    StoyCoLogger.error(error.toString());
    return ExceptionFailure._(
      error: error,
      message: error.toString(),
    );
  }
  ExceptionFailure._({
    this.error,
    required this.message,
  });
  final Exception? error;
  @override
  final String message;
}

class PlatformFailure extends Failure {
  factory PlatformFailure.decode(PlatformException? error) {
    StoyCoLogger.error((error).toString());
    return PlatformFailure._(
      error: error,
      message: error?.message ?? '',
    );
  }

  PlatformFailure._({
    required this.message,
    this.error,
  });
  @override
  final String message;
  final PlatformException? error;
}

class DioFailure extends Failure {
  DioFailure._({
    this.statusCode,
    this.data,
    this.error,
    required this.message,
  });

  factory DioFailure.decode(
    DioException? error,
  ) {
    String message = 'Error desconocido';

    if (error?.response?.statusCode == HttpStatus.unauthorized) {
      message = 'Usuario no autenticado';
    }

    if (error?.response?.statusCode == HttpStatus.forbidden) {
      message = 'Usuario no autorizado';
    }

    if (error?.response?.statusCode == HttpStatus.notFound) {
      message = 'Recurso no encontrado';
    }

    if (error?.response?.statusCode == HttpStatus.methodNotAllowed) {
      message = 'Método no alojado';
    }

    if (error?.response?.statusCode == HttpStatus.requestTimeout) {
      message = 'No pudimos completar la operación';
    }

    if (error?.response?.statusCode == HttpStatus.networkConnectTimeoutError) {
      message = 'No tienes acceso a internet';
    }

    if (error?.response?.statusCode == HttpStatus.internalServerError ||
        error?.response?.statusCode == HttpStatus.serviceUnavailable ||
        error?.response?.statusCode == HttpStatus.badGateway) {
      message = 'Servidor no responde';
    }

    message = error?.message ?? message;

    if (error?.response?.data is Map) {
      final response = error?.response?.data as Map<String, dynamic>;
      message = response['messageError'] ?? response['message'] ?? message;
    }

    return DioFailure._(
      error: error,
      statusCode: error?.response?.statusCode,
      message: message,
      data: error?.response?.data,
    );
  }
  final int? statusCode;
  final dynamic data;
  final DioException? error;
  @override
  final String message;

  DioFailure copyWith({
    String? message,
  }) =>
      DioFailure._(
        error: error,
        statusCode: error?.response?.statusCode,
        message: message ?? error?.message ?? '',
        data: error?.response?.data,
      );
}

class FirebaseFailure extends Failure {
  factory FirebaseFailure.decode(FirebaseException? error) {
    final FirebaseErrorCode errorCode = parseFirebaseErrorCode(error?.code);

    final String message =
        firebaseErrorMessages[errorCode] ?? 'Ocurrió un error desconocido.';

    StoyCoLogger.error((error).toString(), tag: 'FAILURE[FIREBASE[EXCEPTION]]');
    StoyCoLogger.error(
      (error?.message).toString(),
      tag: 'FAILURE[FIREBASE[EXCEPTION]]',
    );
    StoyCoLogger.error(
      (error?.stackTrace).toString(),
      tag: 'FAILURE[FIREBASE[EXCEPTION]][TRACE]',
    );

    return FirebaseFailure._(
      error: error,
      message: message,
      errorCode: errorCode,
    );
  }

  FirebaseFailure._({
    required this.message,
    this.error,
    this.errorCode = FirebaseErrorCode.unknownError,
  });

  final FirebaseErrorCode errorCode;

  @override
  final String message;
  final FirebaseException? error;
}
