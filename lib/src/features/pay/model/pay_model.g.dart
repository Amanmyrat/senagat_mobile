// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PayModelAdapter extends TypeAdapter<PayModel> {
  @override
  final int typeId = 1;

  @override
  PayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PayModel(
      serviceName: fields[0] as String,
      number: fields[1] as String,
      sum: fields[2] as String,
      userName: fields[3] as String,
      serviceIcon: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PayModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.serviceName)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.sum)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.serviceIcon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
