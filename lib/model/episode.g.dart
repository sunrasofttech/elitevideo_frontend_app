// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EpisodeAdapter extends TypeAdapter<Episode> {
  @override
  final int typeId = 7;

  @override
  Episode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Episode(
      coverImg: fields[1] as String?,
      createdAt: fields[10] as dynamic,
      id: fields[0] as String?,
      releasedDate: fields[9] as dynamic,
      status: fields[2] as bool?,
      updatedAt: fields[11] as dynamic,
      videoLink: fields[7] as dynamic,
      continueWatchTime: fields[12] as int?,
      localImagePath: fields[13] as String?,
      localVideoPath: fields[14] as String?,
      userId: fields[15] as String?,
    )
      ..seriesId = fields[3] as dynamic
      ..seasonId = fields[4] as dynamic
      ..episodeName = fields[5] as String?
      ..episodeNo = fields[6] as String?
      ..video = fields[8] as dynamic;
  }

  @override
  void write(BinaryWriter writer, Episode obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.coverImg)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.seriesId)
      ..writeByte(4)
      ..write(obj.seasonId)
      ..writeByte(5)
      ..write(obj.episodeName)
      ..writeByte(6)
      ..write(obj.episodeNo)
      ..writeByte(7)
      ..write(obj.videoLink)
      ..writeByte(8)
      ..write(obj.video)
      ..writeByte(9)
      ..write(obj.releasedDate)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.continueWatchTime)
      ..writeByte(13)
      ..write(obj.localImagePath)
      ..writeByte(14)
      ..write(obj.localVideoPath)
      ..writeByte(15)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EpisodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
