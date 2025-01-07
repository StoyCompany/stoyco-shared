import 'package:dio/dio.dart';
import 'package:stoyco_shared/geo/data/catalog_ds_impl.dart';
import 'package:stoyco_shared/geo/domain/entities/geo_entity.dart';
import 'package:stoyco_shared/stoyco_shared.dart';

class CatalogRepository {
  CatalogRepository(this._catalogDataSource);
  final CatalogDataSource _catalogDataSource;

  Future<List<GeoEntity>> getCitiesByCountryV2(String countryCode) async {
    try {
      final result = await _catalogDataSource.getCitiesByCountryV2(countryCode);
      return result.map((e) => GeoEntity.fromDto(e)).toList();
    } on DioException catch (error) {
      StoyCoLogger.error(
        'Error getCitiesByCountryV2 from CatalogRepository: $error',
      );
      return [];
    } on Error catch (error) {
      StoyCoLogger.error(
        'Error getCitiesByCountryV2 from CatalogRepository: $error',
      );
      return [];
    } on Exception catch (error) {
      StoyCoLogger.error(
        'Error getCitiesByCountryV2 from CatalogRepository: $error',
      );
      return [];
    }
  }

  Future<List<GeoEntity>> getCountriesV2() async {
    try {
      final result = await _catalogDataSource.getCountriesV2();
      return result.map((e) => GeoEntity.fromDto(e)).toList();
    } on DioException catch (error) {
      StoyCoLogger.error(
        'Error getCountriesV2 from CatalogRepository: $error',
      );
      return [];
    } on Error catch (error) {
      StoyCoLogger.error(
        'Error getCountriesV2 from CatalogRepository: $error',
      );
      return [];
    } on Exception catch (error) {
      StoyCoLogger.error(
        'Error getCountriesV2 from CatalogRepository: $error',
      );
      return [];
    }
  }
}
