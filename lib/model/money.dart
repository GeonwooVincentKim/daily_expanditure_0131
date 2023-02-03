import 'package:daily_expanditure_0131/shared/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

// reference this box
final _myBox = Hive.box("money_db");

/*
  Data Structure

  _myBox.get("yyyymmdd") -> habitList
  _myBox.get("START_DATE") -> yyyymmdd
  _myBox.get("CURRENT_MONEY_LIST") -> latest money list
  _myBox.get("TARGET_SUM") -> target sum of money that user planned to use for a day
  _myBox.get("INNER_SUM") -> Calculate the sum of all elements of List (Expanditure) 
  _myBox.get("DIFFERENCR_SUM") -> get the value of `targetSum // (sum = moneyList)`
 
  
  Maybe it will be have
  _myBox.get("HAS_SUM_VALUE") -> Check sum value input first
 */

class Money {
  // Convert List to the Map -> Map<DateTime, int>;
  List moneyList = []; // list of money that user spend for a day
  int targetSum = 0; // target sum of money that user planned to use for a day
  double differenceSum = 0.0; // get the value of `targetSum // (sum = moneyList)`

  // create initial default data
  void createDefaultData() {
    moneyList = [];

    _myBox.put("START_DATE", todaysDateFormatted());
    _myBox.put("TARGET_SUM", targetSum);
    _myBox.put("DIFFERENCE_SUM", differenceSum);
  }

  // load data if is already exists
  void loadData() {
    // if it's a new day, get money list from database
    if (_myBox.get(todaysDateFormatted()) == null) {
      moneyList = _myBox.get("CURRENT_MONEY_LIST");

      // set all money completed to false since it's a new day
      for (int i = 0; i < moneyList.length; i++) {
        moneyList[i][1] = false;
      }
    } else {
      // if it's not a new day, load todays list
      moneyList = _myBox.get(todaysDateFormatted());
      targetSum = _myBox.get("TARGET_SUM");
      differenceSum = _myBox.get("DIFFERENCE_SUM");
    }
  }

  // update database
  void updateDatabase() {
    // update todays entry
    _myBox.put(todaysDateFormatted(), moneyList);

    // update universal money list in case it changed (new habit, edit habit, delete habit)
    _myBox.put("CURRENT_MONEY_LIST", moneyList);
    _myBox.put("TARGET_SUM", targetSum);
    _myBox.put("DIFFERENCE_SUM", differenceSum);
  }
}
