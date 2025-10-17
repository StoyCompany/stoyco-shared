import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/activity/activity_data_source.dart';
import 'package:stoyco_shared/activity/models/message_model.dart';
import 'package:stoyco_shared/jsonapi/json_api_helpers.dart';
import 'package:stoyco_shared/jsonapi/json_api_utils.dart';
import 'package:stoyco_shared/notification/model/notification_model.dart';
import 'package:stoyco_shared/activity/models/user_unified_stats_model.dart';
import 'package:stoyco_shared/activity/models/notification_stats_model.dart';
import 'package:stoyco_shared/activity/models/message_stats_model.dart';
import 'package:stoyco_shared/activity/models/activity_summary_model.dart';

class ActivityRepository {
  ActivityRepository({required ActivityDataSource dataSource})
      : _dataSource = dataSource;

  final ActivityDataSource _dataSource;

  Future<Either<Failure, PageResult<NotificationModel>>> getNotifications({
    int page = 1,
    int limit = 20,
    int? type,
    bool? unreadOnly,
    bool? expiredOnly,
  }) async {
    try {
      final response = await _dataSource.getNotifications(
        page: page,
        limit: limit,
        type: type,
        unreadOnly: unreadOnly,
        expiredOnly: expiredOnly,
      );

      final pageResult = parseJsonApiPageResult<NotificationModel>(
        response.data as Map<String, dynamic>,
        (attrs) => NotificationModel.fromJson(attrs),
      );

      return Right(pageResult);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, PageResult<NotificationModel>>> searchNotifications(
      String q,
      {int page = 1,
      int limit = 20}) async {
    try {
      final response =
          await _dataSource.searchNotifications(q: q, page: page, limit: limit);
      final pageResult = parseJsonApiPageResult<NotificationModel>(
        response.data as Map<String, dynamic>,
        (attrs) => NotificationModel.fromJson(attrs),
      );

      return Right(pageResult);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, bool>> markNotificationViewed(String id) async {
    try {
      final response = await _dataSource.markNotificationViewed(id);
      return Right(response.statusCode == 200 || response.statusCode == 204);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, bool>> deleteNotification(String id) async {
    try {
      final response = await _dataSource.deleteNotification(id);
      return Right(response.statusCode == 200 || response.statusCode == 204);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, NotificationStatsModel>> getNotificationStats(
      {bool? expiredOnly, bool? unreadOnly}) async {
    try {
      final response = await _dataSource.getNotificationStats(
          expiredOnly: expiredOnly, unreadOnly: unreadOnly);
      final data = response.data != null
          ? response.data['data'] as Map<String, dynamic>?
          : null;
      if (data == null) return Right(NotificationStatsModel.fromJson({}));
      final resource = ResourceObject<Map<String, dynamic>>.fromJson(
        data,
        (attrs) => attrs,
      );
      final attrs = resource.attributes;
      final model = NotificationStatsModel.fromJson(attrs);
      return Right(model);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  // Messages
  Future<Either<Failure, PageResult<MessageModel>>> getMessages(
      {int page = 1,
      int limit = 20,
      String? category,
      bool? unreadOnly,
      int? ageDays}) async {
    try {
      final response = await _dataSource.getMessages(
          page: page,
          limit: limit,
          category: category,
          unreadOnly: unreadOnly,
          ageDays: ageDays);
      final pageResult = parseJsonApiPageResult<MessageModel>(
        response.data as Map<String, dynamic>,
        (attrs) => MessageModel.fromJson(attrs),
      );

      return Right(pageResult);
      } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, PageResult<MessageModel>>> searchMessages(String q,
      {int page = 1, int limit = 20}) async {
    try {
      final response =
          await _dataSource.searchMessages(q: q, page: page, limit: limit);
      final pageResult = parseJsonApiPageResult<MessageModel>(
        response.data as Map<String, dynamic>,
        (attrs) => MessageModel.fromJson(attrs),
      );

      return Right(pageResult);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, bool>> markMessageViewed(String id) async {
    try {
      final response = await _dataSource.markMessageViewed(id);
      return Right(response.statusCode == 200 || response.statusCode == 204);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, bool>> deleteMessage(String id) async {
    try {
      final response = await _dataSource.deleteMessage(id);
      return Right(response.statusCode == 200 || response.statusCode == 204);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, MessageStatsModel>> getMessageStats(
      {int? ageDays, bool? unreadOnly}) async {
    try {
      final response = await _dataSource.getMessageStats(
          ageDays: ageDays, unreadOnly: unreadOnly);
      final data = response.data != null
          ? response.data['data'] as Map<String, dynamic>?
          : null;
      if (data == null) return Right(MessageStatsModel.fromJson({}));
      final resource = ResourceObject<Map<String, dynamic>>.fromJson(
        data,
        (attrs) => attrs,
      );
      final attrs = resource.attributes;
      final model = MessageStatsModel.fromJson(attrs);
      return Right(model);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, ActivitySummaryModel>> getActivitySummary(
      {bool? unreadOnly, bool? expiredOnly, int? ageDays}) async {
    try {
      final response = await _dataSource.getActivitySummary(
          unreadOnly: unreadOnly, expiredOnly: expiredOnly, ageDays: ageDays);
      final data = response.data != null
          ? response.data['data'] as Map<String, dynamic>?
          : null;
      if (data == null) return Right(ActivitySummaryModel.fromJson({}));
      final resource = ResourceObject<Map<String, dynamic>>.fromJson(
        data,
        (attrs) => attrs,
      );

      final attrs = resource.attributes;
      final model = ActivitySummaryModel.fromJson(attrs);
      return Right(model);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, UserUnifiedStatsModel>> getUserUnifiedStats(
      {bool? unreadOnly, bool? expiredOnly, int? ageDays}) async {
    try {
      final response = await _dataSource.getUserUnifiedStats(
          unreadOnly: unreadOnly, expiredOnly: expiredOnly, ageDays: ageDays);
      final data = response.data != null
          ? response.data['data'] as Map<String, dynamic>?
          : null;
      if (data == null) return Right(UserUnifiedStatsModel.fromJson({}));
      final resource = ResourceObject<Map<String, dynamic>>.fromJson(
        data,
        (attrs) => attrs,
      );

      final attrs = resource.attributes;
      final model = UserUnifiedStatsModel.fromJson(attrs);
      return Right(model);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }
}
