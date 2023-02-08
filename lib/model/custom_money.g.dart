// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_money.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomMoneyAdapter extends TypeAdapter<CustomMoney> {
  @override
  final int typeId = 2;

  @override
  CustomMoney read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomMoney(
      fields[0] as String,
      targetSum: fields[1] as int?,
      dailySum: fields[2] as int?,
      moneyList: (fields[3] as List?)?.cast<int>(),
      dayRate: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomMoney obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.yearMonthDate)
      ..writeByte(1)
      ..write(obj.targetSum)
      ..writeByte(2)
      ..write(obj.dailySum)
      ..writeByte(3)
      ..write(obj.moneyList)
      ..writeByte(4)
      ..write(obj.dayRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomMoneyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
