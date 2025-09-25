// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movieads.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieAdsAdapter extends TypeAdapter<MovieAds> {
  @override
  final int typeId = 4;

  @override
  MovieAds read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieAds(
      coverImg: fields[3] as dynamic,
      movieLanguage: fields[5] as String?,
      movieName: fields[1] as String?,
      posterImg: fields[4] as dynamic,
      status: fields[2] as bool?,
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, MovieAds obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.movieName)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.coverImg)
      ..writeByte(4)
      ..write(obj.posterImg)
      ..writeByte(5)
      ..write(obj.movieLanguage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieAdsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
