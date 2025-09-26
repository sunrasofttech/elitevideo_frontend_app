import 'package:hive/hive.dart';
part 'episode.g.dart';

@HiveType(typeId: 7)
class Episode extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? coverImg;

  @HiveField(2)
  bool? status;

  @HiveField(3)
  dynamic seriesId;

  @HiveField(4)
  dynamic seasonId;

  @HiveField(5)
  String? episodeName;

  @HiveField(6)
  String? episodeNo;

  @HiveField(7)
  dynamic videoLink;

  @HiveField(8)
  dynamic video;

  @HiveField(9)
  dynamic releasedDate;

  @HiveField(10)
  dynamic createdAt;

  @HiveField(11)
  dynamic updatedAt;

  @HiveField(12)
  int? continueWatchTime;

  @HiveField(13)
  String? localImagePath;

  @HiveField(14)
  String? localVideoPath;

  @HiveField(15)
  String? userId;

  Episode({
    required this.coverImg,
    required this.createdAt,
    required this.id,
    required this.releasedDate,
    required this.status,
    required this.updatedAt,
    required this.videoLink,
    this.continueWatchTime,
    this.localImagePath,
    this.video,
    this.localVideoPath,
    this.episodeName,
    this.episodeNo,
    this.seasonId,
    this.seriesId,
    required this.userId,
  });
}
