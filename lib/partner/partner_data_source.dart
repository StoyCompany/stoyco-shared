import 'package:dio/dio.dart';
import 'package:stoyco_shared/envs/envs.dart';

class PartnerDataSource {
  PartnerDataSource({required this.environment});

  final Dio _dio = Dio();

  final StoycoEnvironment environment;

  /// Gets partner and community data by partner ID using v3 endpoint.
  ///
  /// **Endpoint**: `GET /api/stoyco/v3/partner-community/{id}`
  ///
  /// **IMPORTANT**: This method currently returns mock data for development.
  /// When the real endpoint is ready on the server:
  /// 1. Remove the mock data block (marked with TEMPORARY MOCK comments)
  /// 2. Uncomment the real API call at the bottom of this method
  ///
  /// Returns a [Response] with partner and community data.
  Future<Response> getPartnerCommunityById(String partnerId) async {
    // TEMPORARY MOCK - Remove this block when endpoint is ready
    await Future.delayed(const Duration(milliseconds: 500));

    final mockData = {
      "Partner": {
        "Id": "690bd75ed53b645941ae9f7c",
        "Profile": "Music",
        "CommunityId": "690bd75ed53b645941ae9f7e",
        "Name": "Grupo Poder",
        "Description": "Grupo de musica con sabor",
        "MusicalGenre": "Regional Mexicano",
        "Category": "Requeton",
        "City": "Bogota",
        "Country": "Colombia",
        "CountryFlag": "https://flagicons.lipis.dev/flags/4x3/mx.svg",
        "FrontImage":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmf-tQsMadTZUTWyF-SyrJd5nvIYHSOpNMhQ&s",
        "BannerImage":
            "https://huila.travel/storage/app/uploads/public/64d/fc0/ad8/thumb_23214_600_400_0_0_crop.jpg",
        "AdditionalImages": [
          "https://huila.travel/storage/app/uploads/public/64d/fc0/ad8/thumb_23214_600_400_0_0_crop.jpg",
          "https://huila.travel/storage/app/uploads/public/64d/fc0/ad8/thumb_23214_600_400_0_0_crop.jpg"
        ],
        "SocialNetworkStatistic": {
          "id": "001",
          "Name": "Co-Cre8",
          "Photo":
              "https://d3gxswp30rgfll.cloudfront.net/RFmu38_Co-Cre8.webp?t=1727381335124"
        },
        "SocialNetwork": [
          {
            "Name": "URL Web",
            "Url": "https://web.stoyco.io/",
            "KeyChartMetric": null,
            "Followers": 0
          }
        ],
        "NumberEvents": 0,
        "NumberProducts": 0,
        "CreatedDate": "2025-11-05T18:01:50.663000",
        "Active": true,
        "CollectionId": "488304050497",
        "HandleShopify": "stoyco-2",
        "PartnerUrl": "",
        "FollowersCount": 10,
        "Order": 0,
        "CoLines": "681c3e92181ac22e220f552a",
        "CoTypes": "68373325772fc6dce3ce0384",
        "MainMarketSegment": "683615c72b494351e141dfc5",
        "SecondaryMarketSegments": ["683616722b494351e141dfd1"]
      },
      "Community": {
        "Id": "690bd75ed53b645941ae9f7e",
        "EventId": null,
        "PartnerId": "690bd75ed53b645941ae9f7c",
        "PartnerName": "Grupo Poder",
        "PartnerType": "Music",
        "Name": "Grupo Poderes",
        "NumberOfEvents": null,
        "NumberOfProducts": null,
        "Category": [],
        "NumberOfMembers": 0,
        "BonusMoneyPerUser": "0",
        "CommunityFund": "0",
        "CommunityFundGoal": false,
        "PublishedDate": "2025-11-05T18:01:46.159377",
        "CreatedDate": "2025-11-05T18:01:46.159377",
        "UpdatedDate": "2025-11-05T18:01:46.159377",
        "FullFunds": false,
        "NumberOfProjects": 0,
        "SeshUrl": ""
      }
    };

    return Response(
      requestOptions: RequestOptions(
        path:
            '${environment.baseUrl(version: 'v3')}partner-community/$partnerId',
      ),
      data: mockData,
      statusCode: 200,
    );
    // END TEMPORARY MOCK

    // Uncomment this when the real endpoint is ready:
    // final cancelToken = CancelToken();
    // final response = await _dio.get(
    //   '${environment.baseUrl(version: 'v3')}partner-community/$partnerId',
    //   cancelToken: cancelToken,
    // );
    // return response;
  }

  /// Gets all available market segments.
  ///
  /// **Endpoint**: `GET /api/stoyco/v2/market-segments`
  ///
  /// Market segments are categories used to classify partners and communities
  /// based on their industry, genre, or focus area (e.g., "Pop", "Regional Mexicano", "Trap Latino").
  ///
  /// Returns a [Response] with a list of market segments.
  ///
  /// Example:
  /// ```dart
  /// final response = await dataSource.getMarketSegments();
  /// final segments = (response.data as List)
  ///     .map((json) => MarketSegmentModel.fromJson(json))
  ///     .toList();
  /// ```
  Future<Response> getMarketSegments() async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.urlMarketSegments}market-segments',
      cancelToken: cancelToken,
    );
    return response;
  }
}
