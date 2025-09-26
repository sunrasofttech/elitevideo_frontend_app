// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_film.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShortFilmAdapter extends TypeAdapter<ShortFilm> {
  @override
  final int typeId = 6;

  @override
  ShortFilm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShortFilm(
      category: fields[27] as Genre?,
      coverImg: fields[3] as dynamic,
      createdAt: fields[23] as DateTime?,
      description: fields[13] as String?,
      genre: fields[26] as Genre?,
      genreId: fields[6] as String?,
      id: fields[0] as String?,
      isHighlighted: fields[18] as bool?,
      isMovieOnRent: fields[17] as bool?,
      isWatchlist: fields[19] as bool?,
      language: fields[25] as Genre?,
      movieCategory: fields[7] as dynamic,
      movieLanguage: fields[5] as String?,
      movieRentPrice: fields[15] as String?,
      movieTime: fields[14] as String?,
      posterImg: fields[4] as dynamic,
      quality: fields[11] as dynamic,
      releasedBy: fields[21] as String?,
      releasedDate: fields[22] as String?,
      status: fields[2] as bool?,
      subtitle: fields[12] as dynamic,
      updatedAt: fields[24] as DateTime?,
      videoLink: fields[8] as dynamic,
      continueWatchTime: fields[28] as int?,
      localImagePath: fields[29] as String?,
      localVideoPath: fields[30] as String?,
      averageRating: fields[31] as dynamic,
      ratings: (fields[33] as List?)?.cast<Rating>(),
      totalRatings: fields[32] as dynamic,
      rentedTimeDays: fields[16] as String?,
      shortFilmTitle: fields[1] as String?,
      shortVideo: fields[9] as dynamic,
      showSubscription: fields[10] as dynamic,
      viewCount: fields[20] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ShortFilm obj) {
    writer
      ..writeByte(34)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.shortFilmTitle)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.coverImg)
      ..writeByte(4)
      ..write(obj.posterImg)
      ..writeByte(5)
      ..write(obj.movieLanguage)
      ..writeByte(6)
      ..write(obj.genreId)
      ..writeByte(7)
      ..write(obj.movieCategory)
      ..writeByte(8)
      ..write(obj.videoLink)
      ..writeByte(9)
      ..write(obj.shortVideo)
      ..writeByte(10)
      ..write(obj.showSubscription)
      ..writeByte(11)
      ..write(obj.quality)
      ..writeByte(12)
      ..write(obj.subtitle)
      ..writeByte(13)
      ..write(obj.description)
      ..writeByte(14)
      ..write(obj.movieTime)
      ..writeByte(15)
      ..write(obj.movieRentPrice)
      ..writeByte(16)
      ..write(obj.rentedTimeDays)
      ..writeByte(17)
      ..write(obj.isMovieOnRent)
      ..writeByte(18)
      ..write(obj.isHighlighted)
      ..writeByte(19)
      ..write(obj.isWatchlist)
      ..writeByte(20)
      ..write(obj.viewCount)
      ..writeByte(21)
      ..write(obj.releasedBy)
      ..writeByte(22)
      ..write(obj.releasedDate)
      ..writeByte(23)
      ..write(obj.createdAt)
      ..writeByte(24)
      ..write(obj.updatedAt)
      ..writeByte(25)
      ..write(obj.language)
      ..writeByte(26)
      ..write(obj.genre)
      ..writeByte(27)
      ..write(obj.category)
      ..writeByte(28)
      ..write(obj.continueWatchTime)
      ..writeByte(29)
      ..write(obj.localImagePath)
      ..writeByte(30)
      ..write(obj.localVideoPath)
      ..writeByte(31)
      ..write(obj.averageRating)
      ..writeByte(32)
      ..write(obj.totalRatings)
      ..writeByte(33)
      ..write(obj.ratings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortFilmAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
