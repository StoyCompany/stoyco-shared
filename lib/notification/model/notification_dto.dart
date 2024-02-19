import 'package:equatable/equatable.dart';

class NotificationDto extends Equatable {
  const NotificationDto.fromId({required this.id})
      : guid = null,
        markAsReaded = true;
  const NotificationDto.fromGUId({required this.guid})
      : id = null,
        markAsReaded = true;

  final String? id;
  final String? guid;

  final bool markAsReaded;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'guid': guid,
        'markAsReaded': markAsReaded,
      }..removeWhere((key, value) => value == null);

  @override
  List<Object?> get props => [
        id,
        markAsReaded,
      ];
}
