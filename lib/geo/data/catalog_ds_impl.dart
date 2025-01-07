import 'package:dio/dio.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/geo/data/geo_location_dto/geo_location_dto.dart';

class CatalogDataSource {
  CatalogDataSource({required this.environment});

  /// The current environment.
  final StoycoEnvironment environment;

  /// The Dio instance used for making network requests
  final Dio _dio = Dio();

  Future<List<GeoLocationDto>> getCitiesByCountryV2(String countryCode) async {
    final info = await _dio.get(
      '${environment.dataCatalogUrl}/locations/cities?code=$countryCode',
    );

    return List<GeoLocationDto>.from(
      info.data['data'].map<GeoLocationDto>((e) => GeoLocationDto.fromJson(e)),
    );
  }

  Future<List<GeoLocationDto>> getCountriesV2() async {
    final info = await _dio.get(
      '${environment.dataCatalogUrl}/locations/countries',
    );

    return List<GeoLocationDto>.from(
      info.data['data'].map<GeoLocationDto>((e) => GeoLocationDto.fromJson(e)),
    );
  }
}
