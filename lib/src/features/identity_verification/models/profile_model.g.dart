// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileModelAdapter extends TypeAdapter<ProfileModel> {
  @override
  final int typeId = 2;

  @override
  ProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileModel(
      firstName: fields[0] as String?,
      lastName: fields[1] as String?,
      middleName: fields[2] as String?,
      birthDate: fields[3] as String?,
      passportNumber: fields[4] as String?,
      gender: fields[5] as String?,
      issuedDate: fields[6] as String?,
      issuedBy: fields[7] as String?,
      getPassportScan: fields[8] as String?,
      passportScanPath: fields[9] as String?,
      citizenship: fields[10] as String?,
      homePhone: fields[11] as int?,
      homeAddress: fields[12] as String?,
      status: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.middleName)
      ..writeByte(3)
      ..write(obj.birthDate)
      ..writeByte(4)
      ..write(obj.passportNumber)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.issuedDate)
      ..writeByte(7)
      ..write(obj.issuedBy)
      ..writeByte(8)
      ..write(obj.getPassportScan)
      ..writeByte(9)
      ..write(obj.passportScanPath)
      ..writeByte(10)
      ..write(obj.citizenship)
      ..writeByte(11)
      ..write(obj.homePhone)
      ..writeByte(12)
      ..write(obj.homeAddress)
      ..writeByte(13)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
