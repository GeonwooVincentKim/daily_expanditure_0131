import 'package:hive/hive.dart';

part 'custom_date.g.dart';

@HiveType(typeId: 1)
class CustomDate {
  @HiveField(0)
  DateTime getDate;

  @HiveField(1)
  int rate;

  CustomDate({required this.getDate, required this.rate});
}
