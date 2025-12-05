import 'package:cloud_firestore/cloud_firestore.dart';

/// Radio model according to Firestore specification.
/// Compatible with the existing StationInfo architecture.
class RadioModel {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String partnerId;
  final int? azuraCastStationId;
  final String? radioUrlMp3;
  final String? radioUrlHls;
  final String status;
  final int trackCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  final DateTime? appLastDecrement;
  final DateTime? appLastIncrement;
  final DateTime? lastAppActivity;
  final int membersOnlineCount;


  final int totalDonatedStoyCoins;

  RadioModel({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.partnerId,
    this.azuraCastStationId,
    this.radioUrlMp3,
    this.radioUrlHls,
    required this.status,
    this.trackCount = 0,
    this.createdAt,
    this.updatedAt,
    this.appLastDecrement,
    this.appLastIncrement,
    this.lastAppActivity,
    this.membersOnlineCount = 0,
    this.totalDonatedStoyCoins = 0,
  });

  factory RadioModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RadioModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
      partnerId: data['partnerId'] ?? data['communityOwnerId'] ?? '',
      azuraCastStationId: data['azuraCastStationId'],
      radioUrlMp3: data['radioUrlMp3'],
      radioUrlHls: data['radioUrlHls'],
      status: data['status'] ?? 'inactive',
      trackCount: data['trackCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      appLastDecrement: (data['app_last_decrement'] as Timestamp?)?.toDate(),
      appLastIncrement: (data['app_last_increment'] as Timestamp?)?.toDate(),
      lastAppActivity: (data['last_app_activity'] as Timestamp?)?.toDate(),
      membersOnlineCount: data['members_online_count'] ?? 0,
      totalDonatedStoyCoins: data['totalDonatedStoyCoins'] ?? 0,
    );
  }

  factory RadioModel.fromMap(Map<String, dynamic> data, String documentId) => RadioModel(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
      partnerId: data['partnerId'] ?? data['communityOwnerId'] ?? '',
      azuraCastStationId: data['azuraCastStationId'],
      radioUrlMp3: data['radioUrlMp3'],
      radioUrlHls: data['radioUrlHls'],
      status: data['status'] ?? 'inactive',
      trackCount: data['trackCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      appLastDecrement: (data['app_last_decrement'] as Timestamp?)?.toDate(),
      appLastIncrement: (data['app_last_increment'] as Timestamp?)?.toDate(),
      lastAppActivity: (data['last_app_activity'] as Timestamp?)?.toDate(),
      membersOnlineCount: data['members_online_count'] ?? 0,
      totalDonatedStoyCoins: data['totalDonatedStoyCoins'] ?? 0,
    );

  String? get streamingUrl => radioUrlHls ?? radioUrlMp3;

  bool get isActive => status == 'active';

  bool get hasStreamUrl => streamingUrl != null && streamingUrl!.isNotEmpty;

  RadioModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? partnerId,
    int? azuraCastStationId,
    String? radioUrlMp3,
    String? radioUrlHls,
    String? status,
    int? trackCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? appLastDecrement,
    DateTime? appLastIncrement,
    DateTime? lastAppActivity,
    int? membersOnlineCount,
    int? totalDonatedStoyCoins,
  }) => RadioModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      partnerId: partnerId ?? this.partnerId,
      azuraCastStationId: azuraCastStationId ?? this.azuraCastStationId,
      radioUrlMp3: radioUrlMp3 ?? this.radioUrlMp3,
      radioUrlHls: radioUrlHls ?? this.radioUrlHls,
      status: status ?? this.status,
      trackCount: trackCount ?? this.trackCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      appLastDecrement: appLastDecrement ?? this.appLastDecrement,
      appLastIncrement: appLastIncrement ?? this.appLastIncrement,
      lastAppActivity: lastAppActivity ?? this.lastAppActivity,
      membersOnlineCount: membersOnlineCount ?? this.membersOnlineCount,
      totalDonatedStoyCoins: totalDonatedStoyCoins ?? this.totalDonatedStoyCoins,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'partnerId': partnerId,
      'azuraCastStationId': azuraCastStationId,
      'radioUrlMp3': radioUrlMp3,
      'radioUrlHls': radioUrlHls,
      'status': status,
      'trackCount': trackCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'app_last_decrement': appLastDecrement?.toIso8601String(),
      'app_last_increment': appLastIncrement?.toIso8601String(),
      'last_app_activity': lastAppActivity?.toIso8601String(),
      'members_online_count': membersOnlineCount,
      'totalDonatedStoyCoins': totalDonatedStoyCoins,
    };
}
