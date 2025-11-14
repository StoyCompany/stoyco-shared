import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/news/models/new_model.dart';
import 'package:stoyco_shared/news/news_data_source.dart';

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
