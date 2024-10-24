import 'package:either_dart/either.dart';
import 'package:stoyco_shared/news/news_repository.dart';
import 'package:stoyco_shared/news/models/new_model.dart';
import 'package:stoyco_shared/news/news_data_source.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/coach_mark/coach_mark_data_source.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';

class NewsService {
  factory NewsService({required StoycoEnvironment environment}) =>
      _instance ??= NewsService._(environment: environment);

  NewsService._({required this.environment}) {
    _newsDataSource = NewsDataSource(environment: environment);
    _newsRepository = NewsRepository(newsDataSource: _newsDataSource!);

    _instance = this;
  }

  static NewsService? _instance;

  static NewsService? get instance => _instance;

  StoycoEnvironment environment;

  NewsRepository? _newsRepository;
  NewsDataSource? _newsDataSource;

  Future<Either<Failure, PageResult<NewModel>>> getNewsPaginated(
    int pageNumber,
    int pageSize,
  ) =>
      _newsRepository!.getNewsPaginated(pageNumber, pageSize);

  Future<Either<Failure, PageResult<NewModel>>> getNewsPaginatedWithSearchTerm(
    int pageNumber,
    int pageSize,
    String searchTerm,
  ) =>
      _newsRepository!.getNewsPaginatedWithSearchTerm(
        pageNumber,
        pageSize,
        searchTerm,
      );

  Future<Either<Failure, NewModel>> getNewsById(String id) =>
      _newsRepository!.getNewsById(id);

  Future<Either<Failure, void>> markAsViewed(String id) =>
      _newsRepository!.markAsViewed(id);
}
