// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amiibo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AmiiboModelAdapter extends TypeAdapter<AmiiboModel> {
  @override
  final int typeId = 1;

  @override
  AmiiboModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AmiiboModel(
      id: fields[0] as String,
      name: fields[1] as String,
      character: fields[2] as String,
      imageUrl: fields[3] as String,
      gameSeries: fields[4] as String,
      type: fields[5] as String,
      releaseDates: (fields[6] as Map?)?.cast<String, String>(),
      isFavorite: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AmiiboModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.character)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.gameSeries)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.releaseDates)
      ..writeByte(7)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmiiboModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
