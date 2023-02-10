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
  int dailySum = 0; // get the value of `targetSum - (sum = moneyList)`

  Map<DateTime, int> heatMapDataSet = {};

  // create initial default data
  void createDefaultData() {
    moneyList = [];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  // load data if is already exists
  void loadData() {
    // if it's a new day, get money list from database
    // also get daily_sum and target_sum
    if (_myBox.get(todaysDateFormatted()) == null) {
    } else {
      // if it's not a new day, load todays list
      moneyList = _myBox.get(todaysDateFormatted());
      dailySum = _myBox.get("DAILY_SUM");
      targetSum = _myBox.get("TARGET_SUM");
    }
  }

  // update database
  void updateDatabase() {
    // update todays entry
    _myBox.put(todaysDateFormatted(), moneyList);
    print(heatMapDataSet);

    // update universal money list in case it changed (new habit, edit habit, delete habit)
    _myBox.put("CURRENT_MONEY_LIST", moneyList);
    _myBox.put("DAILY_SUM", dailySum);
    _myBox.put("TARGET_SUM", targetSum);

    // calculate money list in case it change (new money element, edit money element, delete money element)
    calculateMoneyPercentages();

    loadHeatMap();
  }

  void calculateMoneyPercentages() {
    _myBox.get("DAILY_SUM");
    _myBox.get("TARGET_SUM");

    String percent = '';

    if (moneyList.isEmpty) {
      percent = '0.0';
    } else {
      if (dailySum <= targetSum) {
        percent = (dailySum / targetSum).toStringAsFixed(2);
        print("Small");
      } else {
        percent = (targetSum / dailySum).toStringAsFixed(2);
        print("Big");
      }
      
      _myBox.put("DIFFERENCES_SUM_${todaysDateFormatted()}", percent);
    }
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    // count the number of days to load
    int daysInBetweeen = DateTime.now().difference(startDate).inDays;

    // go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetweeen + 1; i++) {
      String yyyymmdd = convertDateTimeToString(startDate.add(Duration(days: i)));
      double strengthAsPercent = double.parse(_myBox.get("DIFFERENCES_SUM_$yyyymmdd") ?? "0.0");
      print("strengthAsPercent -> $strengthAsPercent");

      // split the datatime up like below so it doesn't worry about hours/mins/secs etc.

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;
        
      final Map<DateTime, int> percentForEachDay = {DateTime(year, month, day) : (10 * strengthAsPercent).toInt()};
      
      print("percent For Each day -> $percentForEachDay");
      print("HeatMap Set -> ${DateTime.parse(yyyymmdd)}");

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
