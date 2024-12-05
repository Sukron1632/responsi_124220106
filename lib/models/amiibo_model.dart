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
  final String head;

  @HiveField(7)
  final String tail;

  @HiveField(8)
  final Map<String, String>? releaseDates;

  @HiveField(9)
  bool isFavorite;

  @HiveField(10)  
  final Map<String, String>? amiiboSeries;

  AmiiboModel({
    required this.id,
    required this.name,
    required this.character,
    required this.imageUrl,
    required this.gameSeries,
    required this.type,
    required this.head,
    required this.tail,
    this.amiiboSeries,
    this.releaseDates,
    this.isFavorite = false,
  });

factory AmiiboModel.fromJson(Map<String, dynamic> json) {
  return AmiiboModel(
    id: '${json['head'] ?? ''}${json['tail'] ?? ''}', 
    name: json['name'] ?? 'Unknown', 
    character: json['character'] ?? 'Unknown', 
    imageUrl: json['image'] ?? '', 
    gameSeries: json['gameSeries'] ?? 'Unknown', 
    type: json['type'] ?? 'Unknown', 
    head: json['head'] ?? 'Unknown', 
    tail: json['tail'] ?? 'Unknown', 
    amiiboSeries: json['amiiboSeries'] != null
        ? {'default': json['amiiboSeries']}  
        : {'default': 'Unknown'}, 
    releaseDates: json['release'] != null
        ? Map<String, String>.from(json['release'] ?? {}) 
        : {}, 
    isFavorite: json['isFavorite'] ?? false, 
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'character': character,
      'image': imageUrl,
      'gameSeries': gameSeries,
      'type': type,
      'head': head,
      'tail': tail,
      'release': releaseDates,
      'isFavorite': isFavorite,
      'amiiboSeries': amiiboSeries,  
    };
  }
}
