import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'custom_money.g.dart';

@HiveType(typeId: 2)
class CustomMoney {
  @HiveField(0)
  final String yearMonthDate;

  @HiveField(1)
  int? targetSum;

  @HiveField(2)
  int? dailySum;

  @HiveField(3)
  List<int>? moneyList;

  @HiveField(4)
  double? dayRate;

  CustomMoney(this.yearMonthDate, {this.targetSum, this.dailySum, this.moneyList, this.dayRate});
}
