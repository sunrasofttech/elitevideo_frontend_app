// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GenreAdapter extends TypeAdapter<Genre> {
  @override
  final int typeId = 2;

  @override
  Genre read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Genre(
      coverImg: fields[1] as dynamic,
      id: fields[0] as String?,
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
      name: fields[2] as String?,
      status: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Genre obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.coverImg)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
