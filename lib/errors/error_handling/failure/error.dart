import 'package:hive/hive.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/stoyco_shared.dart';


class ErrorFailure extends Failure {
  factory ErrorFailure.decode(
    Error? error,
  ) {
    StoyCoLogger.error(error.toString());
    return ErrorFailure._(
      error: error,
      message: error.toString(),
    );
  }
  ErrorFailure._({
    this.error,
    required this.message,
  });
  final Error? error;
  @override
  final String message;
}

class HiveFailure extends Failure {
  HiveFailure._({
    this.error,
    required this.message,
  });
  factory HiveFailure.decode(HiveError? error) {
    StoyCoLogger.error(error.toString(), tag: 'HIVEFAILURE');
    StoyCoLogger.error((error?.message).toString(), tag: 'HIVEFAILURE-MESSAGE');
    return HiveFailure._(
      error: error,
      message: error?.message ?? '',
    );
  }
  final HiveError? error;
  @override
  final String message;
}
