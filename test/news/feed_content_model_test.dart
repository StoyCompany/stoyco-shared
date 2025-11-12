import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/news/models/feed_content_model.dart';

void main() {
  group('FeedContentModel JSON Parsing', () {
    test('should parse FeedResponse from JSON correctly', () {
      // Your provided JSON
      final jsonString = '''
      {
        "error": -1,
        "messageError": "",
        "tecMessageError": "",
        "count": 1,
        "data": {
          "items": [
            {
              "contentId": "6903e179265e7a42927041b4",
              "partnerId": "66f5bd918d77fca522545f01",
              "partnerName": "Peso Pluma",
              "partnerProfile": "Music",
              "partnerFrontImage": "https://imagenesstoyco2.s3.amazonaws.com/31w7Lb_NewJeans_HAERIN_Dior_3.webp?t=1761862007058",
              "title": "miosssssssssssssssss",
              "description": "funciona?d",
              "thumbnail": "https://imagenesstoyco2.s3.amazonaws.com/31w7Lb_NewJeans_HAERIN_Dior_3.webp?t=1761862007058",
              "hlsUrl": null,
              "mp4Url": null,
              "contentCreatedAt": "2025-10-30T22:49:34.586Z",
              "isSubscriberOnly": false,
              "mainImage": "https://imagenesstoyco2.s3.amazonaws.com/31w7Lb_NewJeans_HAERIN_Dior_3.webp?t=1761862007058",
              "images": [
                "https://imagenesstoyco2.s3.amazonaws.com/31w7Lb_NewJeans_HAERIN_Dior_3.webp?t=1761862007058"
              ],
              "slider": [],
              "contentHtml": "<p>eefef</p>",
              "detailPath": "/news/6903e179265e7a42927041b4",
              "isSubscribed": null,
              "isFollowed": null,
              "sortWeight": null,
              "likes": 0,
              "dislikes": 0,
              "shares": 0,
              "views": 0,
              "liked": null,
              "disliked": null,
              "sharedCount": null,
              "communityScore": 0,
              "sortTiebreakerId": "6903e179265e7a42927041b4",
              "isFeaturedContent": false
            }
          ],
          "pageNumber": 1,
          "pageSize": 20,
          "totalItems": 1,
          "totalPages": 1
        }
      }
      ''';

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final feedResponse = FeedResponse.fromJson(jsonMap);

      // Verify top-level response
      expect(feedResponse.error, -1);
      expect(feedResponse.messageError, '');
      expect(feedResponse.tecMessageError, '');
      expect(feedResponse.count, 1);

      // Verify data pagination
      expect(feedResponse.data.pageNumber, 1);
      expect(feedResponse.data.pageSize, 20);
      expect(feedResponse.data.totalItems, 1);
      expect(feedResponse.data.totalPages, 1);
      expect(feedResponse.data.items.length, 1);

      // Verify first item
      final item = feedResponse.data.items.first;
      expect(item.contentId, '6903e179265e7a42927041b4');
      expect(item.partnerId, '66f5bd918d77fca522545f01');
      expect(item.partnerName, 'Peso Pluma');
      expect(item.partnerProfile, 'Music');
      expect(item.title, 'miosssssssssssssssss');
      expect(item.description, 'funciona?d');
      expect(item.isSubscriberOnly, false);
      expect(item.mainImage, contains('NewJeans_HAERIN_Dior_3.webp'));
      expect(item.images?.length, 1);
      expect(item.slider?.length, 0);
      expect(item.contentHtml, '<p>eefef</p>');
      expect(item.detailPath, '/news/6903e179265e7a42927041b4');
      expect(item.communityScore, 0);
      expect(item.isFeaturedContent, false);
      expect(item.hlsUrl, isNull);
      expect(item.mp4Url, isNull);
      expect(item.isSubscribed, isNull);
      expect(item.isFollowed, isNull);
      expect(item.sortWeight, isNull);

    });

    test('should serialize FeedResponse back to JSON', () {
      final feedItem = FeedContentItem(
        contentId: 'test123',
        partnerId: 'partner123',
        partnerName: 'Test Partner',
        partnerProfile: 'Sports',
        partnerFrontImage: 'https://example.com/image.png',
        title: 'Test Title',
        description: 'Test Description',
        thumbnail: 'https://example.com/thumb.png',
        contentCreatedAt: '2025-11-10T00:00:00.000Z',
        isSubscriberOnly: true,
        mainImage: 'https://example.com/main.png',
        images: ['https://example.com/image1.png'],
        slider: [],
        contentHtml: '<p>Test HTML</p>',
        detailPath: '/news/test123',
        communityScore: 50,
        sortTiebreakerId: 'test123',
        isFeaturedContent: true,
      );

      final feedData = FeedData(
        items: [feedItem],
        pageNumber: 1,
        pageSize: 20,
        totalItems: 1,
        totalPages: 1,
      );

      final feedResponse = FeedResponse(
        error: -1,
        messageError: '',
        tecMessageError: '',
        count: 1,
        data: feedData,
      );

      final jsonMap = feedResponse.toJson();

      expect(jsonMap['error'], -1);
      expect(jsonMap['count'], 1);

      final dataMap = jsonMap['data'] as Map<String, dynamic>;
      expect(dataMap['pageNumber'], 1);
      expect(dataMap['items'], isList);
      expect((dataMap['items'] as List).length, 1);
    });
  });
}

