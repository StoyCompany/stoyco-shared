import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/news/models/feed_content_model.dart';
import 'package:stoyco_shared/news/models/new_model.dart';
import 'package:stoyco_shared/news/news_data_source.dart';
import 'package:stoyco_shared/widgets/interactive_content_card.dart';

class NewsRepository {
  NewsRepository({required NewsDataSource newsDataSource})
      : _newsDataSource = newsDataSource;

  final NewsDataSource _newsDataSource;

  Future<Either<Failure, PageResult<NewModel>>> getNewsPaginated(
    int pageNumber,
    int pageSize, {
    String? communityOwnerId,
  }) async {
    try {
      final response = await _newsDataSource.getPaged(
        pageNumber: pageNumber,
        pageSize: pageSize,
        communityOwnerId: communityOwnerId,
      );

      final PageResult<NewModel> pageResult = PageResult<NewModel>.fromJson(
        response.data,
        (item) => NewModel.fromJson(item as Map<String, dynamic>),
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


  /// Fetches a paginated list of feed content items.
  ///
  /// Returns an [Either] with [Failure] on the left or [PageResult<FeedContentAdapter>] on the right.
  ///
  /// Example:
  /// ```dart
  /// final result = await newsRepository.getFeedPaginated(1, 20);
  /// ```
  Future<Either<Failure, PageResult<FeedContentAdapter>>> getFeedPaginated(
    int pageNumber,
    int pageSize, {
    String? partnerId,
    String? userId,
    String? partnerProfile,
    bool? onlyNew,
    int? newDays,
    bool? hideSubscriberOnlyIfNotSubscribed,
    String? ct,
    required String feedType,
  }) async {
    try {
      final response = await _newsDataSource.getPagedFeed(
        pageNumber: pageNumber,
        pageSize: pageSize,
        partnerId: partnerId,
        userId: userId,
        partnerProfile: partnerProfile,
        onlyNew: onlyNew,
        newDays: newDays,
        hideSubscriberOnlyIfNotSubscribed: hideSubscriberOnlyIfNotSubscribed,
        ct: ct,
        feedType: feedType
      );

      final feedResponse = FeedResponse.fromJson(response.data as Map<String, dynamic>);
      final feedData = feedResponse.data;
      final pageResult = PageResult<FeedContentAdapter>(
        items: feedData.items
            .map((item) => FeedContentAdapter(item))
            .toList(),
        pageNumber: feedData.pageNumber,
        pageSize: feedData.pageSize,
        totalItems: feedData.totalItems,
        totalPages: feedData.totalPages,
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


  Future<Either<Failure, PageResult<NewModel>>> getNewsPaginatedWithSearchTerm(
    int pageNumber,
    int pageSize,
    String searchTerm,
  ) async {
    try {
      final response = await _newsDataSource.getPaged(
        pageNumber: pageNumber,
        pageSize: pageSize,
        searchTerm: searchTerm,
      );
      final PageResult<NewModel> pageResult = PageResult<NewModel>.fromJson(
        response.data,
        (item) => NewModel.fromJson(item as Map<String, dynamic>),
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

  //getById
  Future<Either<Failure, NewModel>> getNewsById(String id) async {
    try {
      final response = await _newsDataSource.getById(id);
      final NewModel news = NewModel.fromJson(response.data);
      return Right(news);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, bool>> markAsViewed(String id) async {
    try {
      final response = await _newsDataSource.markAsViewed(id);

      return Right(response.statusCode == 204);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }
}
