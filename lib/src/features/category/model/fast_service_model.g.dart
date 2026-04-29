// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fast_service_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************


class FastServiceItemAdapter extends TypeAdapter<FastServiceItem> {
  @override
  final int typeId = 3;

  @override
  FastServiceItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };

    return FastServiceItem(
      type: fields[0] as String,
      phone: fields[1] as String,
      title: fields[2] as String,
      icon: fields[3] as String,
      balance: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FastServiceItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.balance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FastServiceItemAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}