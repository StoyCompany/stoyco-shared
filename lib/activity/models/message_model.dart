import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

/// A model representing a message sent to or from a user.
///
/// The model contains identifying fields, message content, metadata and
/// read status timestamps. All fields are nullable to match the API's
/// optional properties.
@JsonSerializable()
class MessageModel {
  MessageModel({
    String? id,
    String? userId,
    String? messageId,
    String? title,
    String? content,
    String? category,
    bool? isRead,
    bool? seen,
    String? linkText,
    String? linkUrl,
    String? route,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? readAt,
  })  : _id = id,
        _userId = userId,
        _messageId = messageId,
        _title = title,
        _content = content,
        _category = category,
        _isRead = isRead,
        _seen = seen,
        _linkText = linkText,
        _linkUrl = linkUrl,
        _route = route,
        _type = type,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        _readAt = readAt;

  /// Creates a new [MessageModel] from a JSON map.
  ///
  /// The `content` field falls back to `body` if `content` is not present.
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final String? contentFallback =
        json['content'] as String? ?? json['body'] as String?;
    return MessageModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      messageId: json['messageId'] as String?,
      title: json['title'] as String?,
      content: contentFallback,
      category: json['category'] as String?,
      isRead: json['isRead'] as bool?,
      seen: json['seen'] as bool?,
      linkText: json['linkText'] as String?,
      linkUrl: json['linkUrl'] as String?,
      route: json['route'] as String?,
      type: json['type'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.tryParse(json['readAt'] as String),
    );
  }

  final String? _id;
  final String? _userId;
  final String? _messageId;
  final String? _title;
  final String? _content;
  final String? _category;
  final bool? _isRead;
  final bool? _seen;
  final String? _linkText;
  final String? _linkUrl;
  final String? _route;
  final String? _type;
  final DateTime? _createdAt;
  final DateTime? _updatedAt;
  final DateTime? _readAt;

  /// The message identifier.
  String? get id => _id;

  /// The identifier of the user associated with the message.
  String? get userId => _userId;

  /// An alternate message identifier (when present).
  String? get messageId => _messageId;

  /// The message title.
  String? get title => _title;

  /// The message content or body.
  String? get content => _content;

  /// The message category or type.
  String? get category => _category;

  /// Whether the message has been read.
  bool? get isRead => _isRead;

  /// Whether the message has been seen (explicit flag separate from read).
  bool? get seen => _seen;

  /// The link text shown in the message (if any).
  String? get linkText => _linkText;

  /// The link URL attached to the message (if any).
  String? get linkUrl => _linkUrl;

  /// The app route associated with the message.
  String? get route => _route;

  /// The message type (as string). It may represent an integer code.
  String? get type => _type;

  /// The creation timestamp of the message.
  DateTime? get createdAt => _createdAt;

  /// The last updated timestamp for the message.
  DateTime? get updatedAt => _updatedAt;

  /// The timestamp when the message was read, if available.
  DateTime? get readAt => _readAt;

  /// Converts this [MessageModel] into a JSON-compatible map.
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
