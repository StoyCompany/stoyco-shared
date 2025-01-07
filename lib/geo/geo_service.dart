import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/geo/data/catalog_ds_impl.dart';
import 'package:stoyco_shared/geo/data/catalog_repository_impl.dart';
import 'package:stoyco_shared/geo/domain/entities/geo_entity.dart';

class GeoService {
  factory GeoService({
    StoycoEnvironment environment = StoycoEnvironment.development,
  }) {
    instance = GeoService._(
      environment: environment,
    );

    return instance;
  }

  GeoService._({
    this.environment = StoycoEnvironment.development,
  }) {
    _catalogDataSource = CatalogDataSource(
      environment: environment,
    );

    _catalogRepository = CatalogRepository(
      _catalogDataSource!,
    );
  }

  static GeoService instance = GeoService._();

  StoycoEnvironment environment;
  CatalogRepository? _catalogRepository;
  CatalogDataSource? _catalogDataSource;

  Future<List<GeoEntity>> getCountriesV2() =>
      _catalogRepository!.getCountriesV2();

  Future<List<GeoEntity>> getCitiesByCountryV2(String countryCode) =>
      _catalogRepository!.getCitiesByCountryV2(countryCode);
}
