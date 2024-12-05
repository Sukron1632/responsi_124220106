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

  @HiveField(10)  // Menambahkan field baru untuk amiiboSeries
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

  // Factory constructor untuk parsing dari JSON
factory AmiiboModel.fromJson(Map<String, dynamic> json) {
  return AmiiboModel(
    id: '${json['head'] ?? ''}${json['tail'] ?? ''}', // Kombinasi head dan tail, jika null gunakan string kosong
    name: json['name'] ?? 'Unknown', // Default 'Unknown' jika null
    character: json['character'] ?? 'Unknown', // Default 'Unknown' jika null
    imageUrl: json['image'] ?? '', // Default string kosong jika null
    gameSeries: json['gameSeries'] ?? 'Unknown', // Default 'Unknown' jika null
    type: json['type'] ?? 'Unknown', // Default 'Unknown' jika null
    head: json['head'] ?? 'Unknown', // Default 'Unknown' jika null
    tail: json['tail'] ?? 'Unknown', // Default 'Unknown' jika null
    amiiboSeries: json['amiiboSeries'] != null
        ? {'default': json['amiiboSeries']}  // Memastikan value 'amiiboSeries' ada dan diproses dengan benar
        : {'default': 'Unknown'}, // Set default jika null
    releaseDates: json['release'] != null
        ? Map<String, String>.from(json['release'] ?? {}) // Pastikan release adalah map yang valid
        : {}, // Defaultkan ke map kosong jika null
    isFavorite: json['isFavorite'] ?? false, // Default ke false jika null
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
      'amiiboSeries': amiiboSeries,  // Menambahkan properti amiiboSeries
    };
  }
}
