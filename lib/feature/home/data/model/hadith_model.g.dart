


part of 'hadith_model.dart';


class HadithModelAdapter extends TypeAdapter<HadithModel> {
  @override
  final int typeId = 4;

  @override
  HadithModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HadithModel(
      number: fields[0] as int,
      arab: fields[1] as String,
      id: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HadithModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.arab)
      ..writeByte(2)
      ..write(obj.id);
  }
}
