import 'package:either_dart/either.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/news/models/new_model.dart';
import 'package:stoyco_shared/news/news_data_source.dart';
import 'package:stoyco_shared/news/news_repository.dart';

/// A service that handles all operations related to news, including
/// fetching paginated news, searching for news, retrieving a specific
/// news article by its ID, and marking a news item as viewed.
class NewsService {
  /// Factory constructor for creating or accessing a singleton instance of [NewsService].
  ///
  /// The [environment] is required to initialize the service with
  /// the necessary configurations.
  factory NewsService({required StoycoEnvironment environment}) =>
      _instance ??= NewsService._(environment: environment);

  /// Private constructor for internal initialization of the [NewsService].
  ///
  /// This initializes the [_newsDataSource] and [_newsRepository] with
  /// the provided [environment].
  NewsService._({required this.environment}) {
    _newsDataSource = NewsDataSource(environment: environment);
    _newsRepository = NewsRepository(newsDataSource: _newsDataSource!);

    _instance = this;
  }

  /// Singleton instance of the [NewsService].
  static NewsService? _instance;

  /// Getter for retrieving the singleton instance of [NewsService].
  static NewsService? get instance => _instance;

  /// Environment configuration used for initializing data sources and repositories.
  StoycoEnvironment environment;

  /// Repository responsible for handling news operations.
  NewsRepository? _newsRepository;

  /// Data source used to fetch raw news data.
  NewsDataSource? _newsDataSource;

  /// Retrieves a paginated list of news articles.
  ///
  /// This method returns a [PageResult] containing [NewModel] objects,
  /// wrapped in an [Either] to handle possible [Failure] errors.
  ///
  /// * [pageNumber] is the page index to fetch.
  /// * [pageSize] is the number of news items to return in each page.
  ///
  /// Returns:
  /// - [Either] containing either a [Failure] or a [PageResult] of [NewModel].
  Future<Either<Failure, PageResult<NewModel>>> getNewsPaginated(
    int pageNumber,
    int pageSize,
    String? communityOwnerId,
  ) =>
      _newsRepository!.getNewsPaginated(pageNumber, pageSize, communityOwnerId);

  /// Retrieves a paginated list of news articles based on a search term.
  ///
  /// This method allows filtering the news articles by a search term.
  /// It returns a [PageResult] of [NewModel] objects, wrapped in an [Either]
  /// to handle potential [Failure] errors.
  ///
  /// * [pageNumber] is the page index to fetch.
  /// * [pageSize] is the number of news items to return in each page.
  /// * [searchTerm] is the query string used to filter the news.
  ///
  /// Returns:
  /// - [Either] containing either a [Failure] or a [PageResult] of [NewModel].
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

  /// Retrieves a specific news article by its unique identifier.
  ///
  /// * [id] is the unique identifier of the news article.
  ///
  /// Returns:
  /// - [Either] containing either a [Failure] or the requested [NewModel].
  Future<Either<Failure, NewModel>> getNewsById(String id) =>
      _newsRepository!.getNewsById(id);

  /// Marks a specific news article as viewed.
  ///
  /// * [id] is the unique identifier of the news article to be marked as viewed.
  ///
  /// Returns:
  /// - [Either] containing either a [Failure] or [void] if the operation is successful.
  Future<Either<Failure, void>> markAsViewed(String id) =>
      _newsRepository!.markAsViewed(id);
}
