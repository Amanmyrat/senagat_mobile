// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiries_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InquiriesModelAdapter extends TypeAdapter<InquiriesModel> {
  @override
  final int typeId = 0;

  @override
  InquiriesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InquiriesModel(
      id: fields[0] as int?,
      title: fields[1] as String?,
      price: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, InquiriesModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InquiriesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
