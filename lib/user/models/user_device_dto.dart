import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_device_dto.g.dart';

@JsonSerializable()
class UserDeviceDto extends Equatable {
  const UserDeviceDto({
    required this.userId,
    required this.deviceToken,
    this.deviceType = 'Android',
  }) : super();

  @JsonKey(name: 'userId')
  final String? userId;
  @JsonKey(name: 'deviceType')
  final String? deviceType;
  @JsonKey(name: 'deviceToken')
  final String? deviceToken;

  Map<String, dynamic> toJson() => _$UserDeviceDtoToJson(this);

  @override
  List<Object?> get props => [
        userId,
        deviceType,
        deviceToken,
      ];
}
