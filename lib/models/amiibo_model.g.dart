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
      head: fields[6] as String,
      tail: fields[7] as String,
      amiiboSeries: (fields[10] as Map?)?.cast<String, String>(),
      releaseDates: (fields[8] as Map?)?.cast<String, String>(),
      isFavorite: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AmiiboModel obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.head)
      ..writeByte(7)
      ..write(obj.tail)
      ..writeByte(8)
      ..write(obj.releaseDates)
      ..writeByte(9)
      ..write(obj.isFavorite)
      ..writeByte(10)
      ..write(obj.amiiboSeries);
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
