import 'package:hive_flutter/hive_flutter.dart';

// reference this box
final _myBox = Hive.box("daily_db");

class Money {
  List moneyList = [];

  // create initial default data
  void createDefaultData() {
    moneyList = [

    ];
  }

  // load data if is already exists
  void loadData() {

  }

  // update database
  void updateDatabase() {

  }
}
