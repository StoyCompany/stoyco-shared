import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/cache/repository_cache_mixin.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/news/models/feed_content_model.dart';
import 'package:stoyco_shared/news/models/new_model.dart';
import 'package:stoyco_shared/news/news_data_source.dart';
import 'package:stoyco_shared/widgets/interactive_content_card.dart';

class NewsRepository with RepositoryCacheMixin {
  NewsRepository({required NewsDataSource newsDataSource})
      : _newsDataSource = newsDataSource;

  final NewsDataSource _newsDataSource;

  /// Cached for 3 minutes (dynamic news list).
  Future<Either<Failure, PageResult<NewModel>>> getNewsPaginated(
    int pageNumber,
    int pageSize, {
    String? communityOwnerId,
  }) async =>
      cachedCall<PageResult<NewModel>>(
        key: 'news_paginated_${pageNumber}_${pageSize}_$communityOwnerId',
        ttl: const Duration(minutes: 3),
        fetcher: () async {
          try {
            final response = await _newsDataSource.getPaged(
              pageNumber: pageNumber,
              pageSize: pageSize,
              communityOwnerId: communityOwnerId,
            );

            final PageResult<NewModel> pageResult =
                PageResult<NewModel>.fromJson(
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
        },
      );

  /// Fetches a paginated list of feed content items.
  ///
  /// Returns an [Either] with [Failure] on the left or [PageResult<FeedContentAdapter>] on the right.
  ///
  /// Cached for 2 minutes (dynamic feed content).
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
  }) async =>
      cachedCall<PageResult<FeedContentAdapter>>(
        key:
            'feed_paginated_${pageNumber}_${pageSize}_${partnerId}_${userId}_${feedType}_${onlyNew}_$ct',
        ttl: const Duration(minutes: 2),
        fetcher: () async {
          try {
            final response = await _newsDataSource.getPagedFeed(
                pageNumber: pageNumber,
                pageSize: pageSize,
                partnerId: partnerId,
                userId: userId,
                partnerProfile: partnerProfile,
                onlyNew: onlyNew,
                newDays: newDays,
                hideSubscriberOnlyIfNotSubscribed:
                    hideSubscriberOnlyIfNotSubscribed,
                ct: ct,
                feedType: feedType);

            final feedResponse =
                FeedResponse.fromJson(response.data as Map<String, dynamic>);
            final feedData = feedResponse.data;
            final pageResult = PageResult<FeedContentAdapter>(
              items: feedData.items
                  .map((item) =>
                      FeedContentAdapter(item.copyWith(feedType: feedType)))
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
        },
      );

  Future<Either<Failure, PageResult<FeedContentAdapter>>>
      getFeedEventsPaginated(
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
      final response = await _newsDataSource.getPagedFeedEvents(
        pageNumber: pageNumber,
        pageSize: pageSize,
        partnerId: partnerId,
        userId: userId,
        partnerProfile: partnerProfile,
        onlyNew: onlyNew,
        newDays: newDays,
        hideSubscriberOnlyIfNotSubscribed: hideSubscriberOnlyIfNotSubscribed,
        ct: ct,
        feedType: feedType,
      );

      final feedResponse =
          FeedResponse.fromJson(response.data as Map<String, dynamic>);
      final feedData = feedResponse.data;
      final pageResult = PageResult<FeedContentAdapter>(
        items: feedData.items
            .map(
                (item) => FeedContentAdapter(item.copyWith(feedType: feedType)))
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
  ) async =>
      cachedCall<PageResult<NewModel>>(
        key: 'news_search_${pageNumber}_${pageSize}_$searchTerm',
        ttl: const Duration(minutes: 3),
        fetcher: () async {
          try {
            final response = await _newsDataSource.getPaged(
              pageNumber: pageNumber,
              pageSize: pageSize,
              searchTerm: searchTerm,
            );
            final PageResult<NewModel> pageResult =
                PageResult<NewModel>.fromJson(
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
        },
      );

  /// Cached for 10 minutes (individual news item).
  Future<Either<Failure, NewModel>> getNewsById(String id) async =>
      cachedCall<NewModel>(
        key: 'news_by_id_$id',
        ttl: const Duration(minutes: 10),
        fetcher: () async {
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
        },
      );

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
