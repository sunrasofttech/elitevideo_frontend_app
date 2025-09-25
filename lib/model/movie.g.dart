// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 0;

  @override
  Movie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie(
      category: fields[26] as Genre?,
      coverImg: fields[3] as dynamic,
      createdAt: fields[22] as DateTime?,
      description: fields[14] as String?,
      genre: fields[25] as Genre?,
      genreId: fields[6] as String?,
      id: fields[0] as String?,
      isHighlighted: fields[18] as bool?,
      isMovieOnRent: fields[17] as bool?,
      isWatchlist: fields[19] as bool?,
      language: fields[24] as Genre?,
      movieCategory: fields[7] as dynamic,
      movieLanguage: fields[5] as String?,
      movieName: fields[1] as String?,
      movieRentPrice: fields[16] as String?,
      movieTime: fields[15] as String?,
      movieVideo: fields[36] as dynamic,
      posterImg: fields[4] as dynamic,
      quality: fields[12] as bool?,
      releasedBy: fields[20] as String?,
      releasedDate: fields[21] as String?,
      status: fields[2] as bool?,
      subtitle: fields[13] as bool?,
      trailorVideo: fields[11] as dynamic,
      trailorVideoLink: fields[10] as dynamic,
      updatedAt: fields[23] as DateTime?,
      videoLink: fields[9] as dynamic,
      userId: fields[37] as String?,
      continueWatchTime: fields[27] as int?,
      localImagePath: fields[28] as String?,
      localVideoPath: fields[29] as String?,
      averageRating: fields[30] as dynamic,
      castCrew: (fields[33] as List?)?.cast<CastCrew>(),
      movieAd: (fields[34] as List?)?.cast<MovieAds>(),
      ratings: (fields[32] as List?)?.cast<Rating>(),
      recommendedMovies: (fields[35] as List?)?.cast<Movie>(),
      reportCount: fields[8] as dynamic,
      totalRatings: fields[31] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(38)
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
      ..write(obj.movieLanguage)
      ..writeByte(6)
      ..write(obj.genreId)
      ..writeByte(7)
      ..write(obj.movieCategory)
      ..writeByte(8)
      ..write(obj.reportCount)
      ..writeByte(9)
      ..write(obj.videoLink)
      ..writeByte(36)
      ..write(obj.movieVideo)
      ..writeByte(10)
      ..write(obj.trailorVideoLink)
      ..writeByte(11)
      ..write(obj.trailorVideo)
      ..writeByte(12)
      ..write(obj.quality)
      ..writeByte(13)
      ..write(obj.subtitle)
      ..writeByte(14)
      ..write(obj.description)
      ..writeByte(15)
      ..write(obj.movieTime)
      ..writeByte(16)
      ..write(obj.movieRentPrice)
      ..writeByte(17)
      ..write(obj.isMovieOnRent)
      ..writeByte(18)
      ..write(obj.isHighlighted)
      ..writeByte(19)
      ..write(obj.isWatchlist)
      ..writeByte(20)
      ..write(obj.releasedBy)
      ..writeByte(21)
      ..write(obj.releasedDate)
      ..writeByte(22)
      ..write(obj.createdAt)
      ..writeByte(23)
      ..write(obj.updatedAt)
      ..writeByte(24)
      ..write(obj.language)
      ..writeByte(25)
      ..write(obj.genre)
      ..writeByte(26)
      ..write(obj.category)
      ..writeByte(27)
      ..write(obj.continueWatchTime)
      ..writeByte(28)
      ..write(obj.localImagePath)
      ..writeByte(29)
      ..write(obj.localVideoPath)
      ..writeByte(30)
      ..write(obj.averageRating)
      ..writeByte(31)
      ..write(obj.totalRatings)
      ..writeByte(32)
      ..write(obj.ratings)
      ..writeByte(33)
      ..write(obj.castCrew)
      ..writeByte(34)
      ..write(obj.movieAd)
      ..writeByte(35)
      ..write(obj.recommendedMovies)
      ..writeByte(37)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
