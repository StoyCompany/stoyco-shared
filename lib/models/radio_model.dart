import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a radio station from Firestore.
///
/// Compatible with the existing StationInfo architecture.
class RadioModel {
  /// Unique Firestore document ID.
  final String id;

  /// Radio station title.
  final String title;

  /// Optional description of the radio.
  final String? description;

  /// Optional cover image URL.
  final String? imageUrl;

  /// Community owner/partner ID.
  final String partnerId;

  /// AzuraCast station identifier.
  final int? azuraCastStationId;

  /// MP3 streaming URL.
  final String? radioUrlMp3;

  /// HLS streaming URL.
  final String? radioUrlHls;

  /// Status of the radio (active/inactive).
  final String status;

  /// Number of tracks in the station.
  final int trackCount;

  /// Timestamp when the radio was created.
  final DateTime? createdAt;

  /// Timestamp of the last update.
  final DateTime? updatedAt;

  /// Timestamp of the last listener decrement from app.
  final DateTime? appLastDecrement;

  /// Timestamp of the last listener increment from app.
  final DateTime? appLastIncrement;

  /// Timestamp of the last app activity.
  final DateTime? lastAppActivity;


  /// Total number of playbacks (users who listened ≥ 1 minute).
  /// This is a cumulative counter that only increments, never decrements.
  final int playbackCount;

  /// Total StoyCoins donated to this radio.
  final int totalDonatedStoyCoins;

  /// Creates a [RadioModel] instance.
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
    this.playbackCount = 0,
    this.totalDonatedStoyCoins = 0,
  });

  /// Creates a [RadioModel] from a Firestore document snapshot.
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
      playbackCount: data['playback_count'] ?? 0,
      totalDonatedStoyCoins: data['totalDonatedStoyCoins'] ?? 0,
    );
  }

  /// Creates a [RadioModel] from a map and document ID.
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
      playbackCount: data['playback_count'] ?? 0,
      totalDonatedStoyCoins: data['totalDonatedStoyCoins'] ?? 0,
    );

  /// Returns the preferred streaming URL (HLS or MP3).
  String? get streamingUrl => radioUrlHls ?? radioUrlMp3;

  /// Whether the radio is active.
  bool get isActive => status == 'active';

  /// Whether the radio has a valid streaming URL.
  bool get hasStreamUrl => streamingUrl != null && streamingUrl!.isNotEmpty;

  /// Creates a copy with optional field modifications.
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
    int? playbackCount,
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
      playbackCount: playbackCount ?? this.playbackCount,
      totalDonatedStoyCoins: totalDonatedStoyCoins ?? this.totalDonatedStoyCoins,
    );

  /// Converts this model to a JSON map.
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
      'playback_count': playbackCount,
      'totalDonatedStoyCoins': totalDonatedStoyCoins,
    };
}
