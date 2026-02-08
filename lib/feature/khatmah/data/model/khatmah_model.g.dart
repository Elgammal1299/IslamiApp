// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khatmah_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JuzProgressAdapter extends TypeAdapter<JuzProgress> {
  @override
  final int typeId = 2;

  @override
  JuzProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JuzProgress(
      juzNumber: fields[0] as int,
      startPage: fields[1] as int,
      endPage: fields[2] as int,
      currentPage: fields[3] as int,
      isCompleted: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, JuzProgress obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.juzNumber)
      ..writeByte(1)
      ..write(obj.startPage)
      ..writeByte(2)
      ..write(obj.endPage)
      ..writeByte(3)
      ..write(obj.currentPage)
      ..writeByte(4)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JuzProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyProgressAdapter extends TypeAdapter<DailyProgress> {
  @override
  final int typeId = 1;

  @override
  DailyProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyProgress(
      dayNumber: fields[0] as int,
      date: fields[1] as DateTime,
      juzList: (fields[2] as List).cast<JuzProgress>(),
      isCompleted: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DailyProgress obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dayNumber)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.juzList)
      ..writeByte(3)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KhatmahModelAdapter extends TypeAdapter<KhatmahModel> {
  @override
  final int typeId = 0;

  @override
  KhatmahModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KhatmahModel(
      id: fields[0] as String,
      name: fields[1] as String,
      totalDays: fields[2] as int,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime,
      dailyProgress: (fields[5] as List).cast<DailyProgress>(),
      isCompleted: fields[6] as bool,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, KhatmahModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.totalDays)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.dailyProgress)
      ..writeByte(6)
      ..write(obj.isCompleted)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KhatmahModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
