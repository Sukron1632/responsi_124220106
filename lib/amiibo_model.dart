import 'package:hive/hive.dart';

part 'amiibo_model.g.dart';

@HiveType(typeId: 1)
class AmiiboModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String character;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String gameSeries;

  @HiveField(5)
  final String type;

  @HiveField(6)
  final Map<String, String>? releaseDates;

  @HiveField(7)
  bool isFavorite;

  AmiiboModel({
    required this.id,
    required this.name,
    required this.character,
    required this.imageUrl,
    required this.gameSeries,
    required this.type,
    this.releaseDates,
    this.isFavorite = false,
  });


  factory AmiiboModel.fromJson(Map<String, dynamic> json) {
    return AmiiboModel(
      id: '${json['head'] ?? ''}${json['tail'] ?? ''}',
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      imageUrl: json['image'] ?? '',
      gameSeries: json['gameSeries'] ?? '',
      type: json['type'] ?? '',
      releaseDates: json['release'] != null
          ? Map<String, String>.from(json['release'])
          : null,
      isFavorite: false,
    );
  }

 
  String get description => '$name from $gameSeries';
  String get category => type;
  String get gameOrigin => gameSeries;


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'character': character,
      'image': imageUrl,
      'gameSeries': gameSeries,
      'type': type,
      'release': releaseDates,
      'isFavorite': isFavorite,
    };
  }
}
