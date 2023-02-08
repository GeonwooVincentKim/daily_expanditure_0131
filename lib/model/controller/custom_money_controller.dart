import 'package:daily_expanditure_0131/model/custom_money.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CustomMoneyController {
  final box = Hive.openBox<CustomMoney>("money");

  void initModel() {
    print(box);
  }

  void updateModel() {
    
  }
  
  void addModel() {

  }

  void deleteModel() {

  }
}
