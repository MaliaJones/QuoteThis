// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalItemAdapter extends TypeAdapter<GoalItem> {
  @override
  final int typeId = 1;

  @override
  GoalItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalItem(
      goalTxt: fields[0] as String,
      goalNum: fields[1] as int,
      icon: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GoalItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.goalTxt)
      ..writeByte(1)
      ..write(obj.goalNum)
      ..writeByte(2)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
