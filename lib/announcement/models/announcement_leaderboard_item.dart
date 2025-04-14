import 'package:stoyco_shared/announcement/models/user_announcement/user_announcement.dart';

class AnnouncementLeaderboardItem {
  factory AnnouncementLeaderboardItem.fromUserAnnouncement(
          UserAnnouncement userAnnouncement, int position) =>
      AnnouncementLeaderboardItem(
        position: position,
        userImageUrl: userAnnouncement.userPhoto ?? '',
        tiktokUserName: userAnnouncement.username ?? '',
        totalPost: userAnnouncement.metrics?.totalPublications ?? 0,
        totalLikes: userAnnouncement.metrics?.totalLikes ?? 0,
        userId: userAnnouncement.userId ?? '',
        platform: userAnnouncement.platform ?? '',
      );
  AnnouncementLeaderboardItem({
    required this.position,
    required this.userImageUrl,
    required this.tiktokUserName,
    required this.totalPost,
    required this.totalLikes,
    required this.userId,
    required this.platform,
  });
  final int position;
  final String userImageUrl;
  final String tiktokUserName;
  final int totalPost;
  final int totalLikes;
  final String userId;
  final String platform;

  String get urlPlatform => _buildUrlPlatform(
        platform,
        tiktokUserName,
      );

  static List<AnnouncementLeaderboardItem> fromUserAnnouncements(
          List<UserAnnouncement> userAnnouncements) =>
      userAnnouncements
          .asMap()
          .entries
          .map((entry) => AnnouncementLeaderboardItem.fromUserAnnouncement(
              entry.value, entry.key + 1))
          .toList();

  /// Builds a URL for a social media platform based on the platform name and username.
  ///
  /// Takes [platform] (e.g., "instagram", "facebook") and [userName] and returns
  /// the appropriate social media profile URL.
  ///
  /// The [userName] can be provided with or without the '@' prefix.
  ///
  /// Returns an empty string if the platform is not recognized.
  ///
  /// Example:
  /// ```dart
  /// // Returns "https://www.instagram.com/username"
  /// final url = AnnouncementDetailsUtils.buildUrlPlatform('instagram', '@username');
  /// ```
  String _buildUrlPlatform(String platform, String userName) {
    String url = '';
    final String normalizedPlatform = platform.toLowerCase();

    final String displayUserName =
        userName.startsWith('@') ? userName : '@$userName';
    final String formattedUserName = displayUserName.substring(1);

    switch (normalizedPlatform) {
      case 'instagram':
        url = 'https://www.instagram.com/$formattedUserName';
      case 'facebook':
        url = 'https://www.facebook.com/$formattedUserName';
      case 'twitter':
      case 'x':
        url = 'https://twitter.com/$formattedUserName';
      case 'linkedin':
        url = 'https://www.linkedin.com/in/$formattedUserName';
      case 'tiktok':
        url = 'https://www.tiktok.com/@$formattedUserName';
      default:
        url = '';
    }

    return url;
  }
}
