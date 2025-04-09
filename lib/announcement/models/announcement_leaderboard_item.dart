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
      );
  AnnouncementLeaderboardItem({
    required this.position,
    required this.userImageUrl,
    required this.tiktokUserName,
    required this.totalPost,
    required this.totalLikes,
    required this.userId,
  });
  final int position;
  final String userImageUrl;
  final String tiktokUserName;
  final int totalPost;
  final int totalLikes;
  final String userId;

  static List<AnnouncementLeaderboardItem> fromUserAnnouncements(
          List<UserAnnouncement> userAnnouncements) =>
      userAnnouncements
          .asMap()
          .entries
          .map((entry) => AnnouncementLeaderboardItem.fromUserAnnouncement(
              entry.value, entry.key + 1))
          .toList();
}
