// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationModelAdapter extends TypeAdapter<NotificationModel> {
  @override
  final int typeId = 5;

  @override
  NotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationModel(
      id: fields[0] as String?,
      guid: fields[10] as String?,
      itemId: fields[1] as String?,
      userId: fields[2] as String?,
      title: fields[3] as String?,
      text: fields[4] as String?,
      image: fields[5] as String?,
      type: fields[6] as int?,
      color: fields[7] as String?,
      isReaded: fields[8] as bool?,
      createAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.text)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.color)
      ..writeByte(8)
      ..write(obj.isReaded)
      ..writeByte(9)
      ..write(obj.createAt)
      ..writeByte(10)
      ..write(obj.guid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
