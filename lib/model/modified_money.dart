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
  int dailySum = 0; // get the value of `targetSum - (sum = moneyList)`
  double newDifferenceSum = 0.0;

  Map<DateTime, int> heatMapDataSet = {};

  // create initial default data
  void createDefaultData(String _workDate) {
    moneyList = [];

    _myBox.put("START_DATE", _workDate);
    _myBox.put("TARGET_SUM", targetSum);
    _myBox.put("DIFFERENCE_SUM_${_workDate}", differenceSum);
    _myBox.put("DAILY_SUM", dailySum);
    // _myBox.put("HEAT_MAP_DATASET", heatMapDataSet);
  }

  // load data if is already exists
  void loadData() {
    // if it's a new day, get money list from database
    // also get daily_sum and target_sum
    if (_myBox.get(todaysDateFormatted()) == null) {
      moneyList = _myBox.get("CURRENT_MONEY_LIST");
      dailySum = _myBox.get("DAILY_SUM");
      targetSum = _myBox.get("TARGET_SUM");

      // set all money completed to false since it's a new day
      // for (int i = 0; i < moneyList.length; i++) {
      //   moneyList[i][1] = true;
      // }
    } else {
      // if it's not a new day, load todays list
      moneyList = _myBox.get("CURRENT_MONEY_LIST");
      // moneyList = _myBox.get(todaysDateFormatted());
      targetSum = _myBox.get("TARGET_SUM");
      differenceSum = _myBox.get("DIFFERENCE_SUM_${todaysDateFormatted()}");
      dailySum = _myBox.get("DAILY_SUM");
      // heatMapDataSet = _myBox.get(todaysDateFormatted());
    }
  }

  // update database
  void updateDatabase() {
    // update todays entry
    _myBox.put(todaysDateFormatted(), moneyList);
    // _myBox.put(todaysDateFormatted() + "DIFFERENCE_SUM_${todaysDateFormatted()}" + "TARGET_SUM" + "DAILY_SUM", moneyList);
    print(heatMapDataSet);
    // _myBox.put(todaysDateFormatted(), targetSum);
    // _myBox.put(todaysDateFormatted(), dailySum);
    // _myBox.put(todaysDateFormatted(), differenceSum);
    // _myBox.put(todaysDateFormatted(), heatMapDataSet);
    
    // update universal money list in case it changed (new habit, edit habit, delete habit)
    _myBox.put("CURRENT_MONEY_LIST", moneyList);
    _myBox.put("TARGET_SUM", targetSum);
    _myBox.put("DIFFERENCE_SUM_${todaysDateFormatted()}", differenceSum);
    _myBox.put("DAILY_SUM", dailySum);

    heatMapDataSet[DateTime.parse(todaysDateFormatted())] = differenceSum.toInt();
    

    // calculate money list in case it change (new money element, edit money element, delete money element)
    // calculateMoneyPercentages();

    loadHeatMap();
  }

  void calculateMoneyPercentages() {
    if (moneyList.isNotEmpty && differenceSum != 0.0) {
      print("differentSum -> $differenceSum");

      String percent = moneyList.isEmpty
        ? '0.0'
        : (differenceSum / moneyList.length).toStringAsFixed(2);
      
      print("Get Sum~! -> $percent");
      _myBox.put("NEW_DIFFERENCE_SUM_${todaysDateFormatted()}", percent);
    }
  }

  void loadHeatMap() {
    //DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));
    DateTime startDate = createDateTimeObject('20230201');
    int daysInBetweeen = DateTime.now().difference(startDate).inDays;


    for (int i = 0; i <= daysInBetweeen; i++) {
      String yyyymmdd = convertDateTimeToString(startDate.add(Duration(days: i)));
      var differenceSum = _myBox.get("DIFFERENCE_SUM_${yyyymmdd}");

      if (differenceSum.isNotEmpty && differenceSum != 0.0) {
        final Map<DateTime, int> percentForEachDay = {DateTime.parse(yyyymmdd) : differenceSum};

        heatMapDataSet.addEntries(percentForEachDay.entries);
      }
    }
  }
}
