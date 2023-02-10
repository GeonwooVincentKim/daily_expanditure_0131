import 'package:hive/hive.dart';

part 'custom_daily_money.g.dart';

@HiveType(typeId: 1)
class CustomDailyMoney {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int elementSize;

  CustomDailyMoney({required this.id, required this.elementSize});
}

