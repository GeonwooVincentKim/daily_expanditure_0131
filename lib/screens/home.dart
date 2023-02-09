import 'package:daily_expanditure_0131/model/money.dart';
import 'package:daily_expanditure_0131/shared/date_time.dart';
import 'package:daily_expanditure_0131/shared/date_util.dart';
import 'package:daily_expanditure_0131/shared/style.dart';
import 'package:daily_expanditure_0131/widgets/custom/column_row/custom_row.dart';
import 'package:daily_expanditure_0131/widgets/custom/custom_alert_dialog_box.dart';
import 'package:daily_expanditure_0131/widgets/custom/custom_circle_avatar.dart';
import 'package:daily_expanditure_0131/widgets/custom/custom_elevated_button.dart';
import 'package:daily_expanditure_0131/widgets/daily_expanditure_tile.dart';
import 'package:daily_expanditure_0131/widgets/heatmap/heatmap_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Money db = Money();
  Box<dynamic> _myBox = Hive.box("money_db");
  late String _workDate;
  late DateTime _startDate;
  late DateTime _endDate;

  double newDifferenceSum = 0.0;

  @override
  void initState() {
    // if there is no current money list, then it is the 1st time ever opening the app
    // then create default data
    _workDate = getToday();
    // _workDate = todaysDateFormatted();
    // _workDate = DateFormat('yyyyMMdd').format(_startDate);
    // _startDate = DateTime.parse('yyyymmdd');

    if ((_myBox.get("CURRENT_MONEY_LIST") == null) || (_myBox.get("TARGET_SUM") == null)) {
      db.createDefaultData(_workDate);
    } else {
      // already exists data
      db.loadData();
    }

    // db.loadHeatMap();

    // update db
    db.updateDatabase();

    super.initState();
  }

  bool? hasSumValue; // Check sum value input first

  final _newMoneyElementController = TextEditingController();
  final _newTargetAmountController = TextEditingController();

  int innerSum = 0; // Calculate the sum of all elements of List (Expanditure)
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.grey[300],
      child: Column(
        children: [
          _widgetTargetAmount(db.targetSum, true), // allows to set true input value anytime user wants
          
          // dummay variable to check the difference of targetSum and moneyList
          Text('${db.differenceSum}', style: const TextStyle(color: CupertinoColors.black),),
          // HeatmapSummary(datasets: db.heatMapDataSet, startDate: _myBox.get("START_DATE")),
          HeatmapSummary(datasets: db.heatMapDataSet),

          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: db.moneyList.length,
              itemBuilder: (context, index) {
                return DailyExpanditureTile(
                  elementName: int.parse(db.moneyList[index][0]),
                  elementIncluded: db.moneyList[index][1],
                  // settingsTapped: (context) => openExpandSettings(index),
                  deleteTapped: (context) => deleteExpand(index),
                );
              },
            ),
          ),
          // Expanded(
            // child: Align(
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [ 
                  _widgetDailyOutlays(db.dailySum),
                  CustomElevatedButton(getValue: "Google Ads", customFixedSize: Size(MediaQuery.of(context).size.width * 0.9, 60))
                ],
              ),
            ),
          // )
        ],
      ),
    );
  }

  // TargetAmount
  CustomRow _widgetTargetAmount(int targetSum, bool hasSumValue) {
    return CustomRow(
      children: [
        const SizedBox(width: 50),

        ElevatedButton(
          onPressed: () => false,
          child: Text("$targetSum"),
        ),

        const SizedBox(width:35),
        GestureDetector(
          onTap: () {
            createNewExpanditure(_newTargetAmountController, saveTargetAmount, cancelDialogBox);
          },
          child: const CustomCircleAvatar(backgroundColor: transparentColor, icon: CupertinoIcons.creditcard, iconColor: buttonTextColor, size: 35),
        )
      ],
    );
  }

  // List of Expanditure
  CustomRow _widgetDailyOutlays(int dailySum) {
    return CustomRow(
      children: [
        const Text("하루지출"),
        const SizedBox(width: 20),

        ElevatedButton(
          onPressed: () => false,
          child: Text("$dailySum"),
        ),

        const SizedBox(width: 35),
        GestureDetector(
          onTap: () {
            createNewExpanditure(_newMoneyElementController, saveNewExpand, cancelDialogBox);
          },
          child: const CustomCircleAvatar(backgroundColor: swipeIconColor, icon: CupertinoIcons.plus, iconColor: plusIconColor, size: 35)
        )
      ],
    );
  }

  // Input the new element of the list (expanditure)
  // Input the targer value to controll hasSumValue
  void createNewExpanditure(TextEditingController textController, onSave, onCancel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialogBox(
          controller: textController,
          hintText: "입력하세요",
          // hasSumValue: (targetSum <= 0) ? false : true,
          hasSumValue: (textController == _newMoneyElementController && db.targetSum <= 0) ? false : true,
          onSave: onSave,
          onCancel: onCancel,
        );
      }
    );
  }

  // List of expanditure of today (Create - List)
  void saveNewExpand() {
    setState(() {
      db.moneyList.add([_newMoneyElementController.text, false]);
      // print(db.moneyList.runtimeType);

      print("length -> ${db.moneyList.length}");
      
      // Calculate the sum
      saveDifference(innerSum, '+');
    });

    print("sumValue ? -> $hasSumValue");
    if (hasSumValue == true) {
      _newMoneyElementController.clear();
    }
    Navigator.of(context).pop();

    db.updateDatabase();
  }

  // Save the difference of TargetSum and moneyList
  void saveDifference(int innerSum, String sign) {
    // Not to set as String
    // This may cause type case error
    // Make sure parse the String value to Integer.
    print("Exist ?? -> ${db.moneyList}");

    for (int i = 0; i < db.moneyList.length; i++) {
      // print(db.moneyList[i][0].runtimeType); // Get current value's type
      print("Values -> ${int.parse(db.moneyList[i][0])}");
      // print("Plus -> ${int.parse(db.moneyList[i][0]) + int.parse(db.moneyList[i][0])}");
    
      if (sign == '+') {
        innerSum += int.parse(db.moneyList[i][0]); // Store into the innerSum
      } else if (sign == '-') {
        innerSum -= int.parse(db.moneyList[i][0]); // Store into the innerSum
      }
    }    
    
    // Get DailySum from innerSum
    db.dailySum = innerSum.abs();
    
    // If dailySum is less smaller than targetSum, divide innerSum by targetSum
    // Otherwise, divide dailySum by targetSum.
    String percent = "";

    if (db.moneyList.isEmpty) {
      percent = "0.0";
    } else {
      if (db.dailySum <= db.targetSum) {
        percent = (innerSum / db.targetSum).abs().toStringAsFixed(2);

        // db.differenceSum = double.parse((innerSum / db.targetSum).abs().toStringAsFixed(2));
        // newDifferenceSum = db.differenceSum;
        // print("Get -> $newDifferenceSum");
        // _myBox.put("NEW_DIFFERENCE_SUM_${todaysDateFormatted()}", newDifferenceSum);
        // _myBox.put("DIFFERENCE_SUM_${todaysDateFormatted()}", newDifferenceSum);
      
        _myBox.put("DIFFERENCE_SUM_${todaysDateFormatted()}", percent);
      } else if (db.dailySum > db.targetSum) {
        percent = (db.targetSum / innerSum).abs().toStringAsFixed(2);
        // db.differenceSum = double.parse((db.targetSum / innerSum).abs().toStringAsFixed(2));
        // newDifferenceSum = db.differenceSum;
        // print("Get -> $newDifferenceSum");
        // _myBox.put("NEW_DIFFERENCE_SUM_${todaysDateFormatted()}", newDifferenceSum);
        _myBox.put("DIFFERENCE_SUM_${todaysDateFormatted()}", percent);
      }
    }

    print('Get SUM -> ${db.differenceSum}');
    print('Get Daily Sum -> ${innerSum.abs()}');
    
    if (innerSum.abs() < db.targetSum) {
      print("Difference -> ${(innerSum / db.targetSum).abs()}");
      print("Difference (2 digit) -> ${double.parse((innerSum / db.targetSum).abs().toStringAsFixed(2))}");
    } else if (innerSum.abs() > db.targetSum) {
      print("Difference -> ${(db.targetSum / innerSum).abs()}");
      print("Difference (2 digit) -> ${double.parse((db.targetSum / innerSum).abs().toStringAsFixed(2))}");
    }


    // If targetSum didn't input before input the value of innerSum,
    // return hasSumValue false
    // Otherwise return true
    if (db.targetSum == 0) {
      hasSumValue = false;
    } else {
      hasSumValue = true;
    }

    // DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));
    // print(startDate);
    // // count the number of days to load
    // int daysInBetweeen = DateTime.now().difference(startDate).inDays;

    // // go from start date to today and add each percentage to the dataset
    // // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    // for (int i = 0; i < daysInBetweeen + 1; i++) {
    //   String yyyymmdd = convertDateTimeToString(startDate.add(Duration(days: 1)));
    //   // double strengthAsPercent = double.parse(_myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0");
    //   double strengthAsPercent = db.differenceSum * 10;
    //   // double strengthAsPercent = double.parse(_myBox.get("NEW_DIFFERENCE_SUM_$yyyymmdd") ?? "0.0");
    //   print("strengthAsPercent -> $strengthAsPercent");


    //   // newDifferenceSum = double.parse(_myBox.get("NEW_DIFFERENCE_SUM_$yyyymmdd") ?? "0.0");
    //   // print("strengthAsPercent -> $newDifferenceSum");

    //   // split the datatime up like below so it doesn't worry about hours/mins/secs etc.

    //   // year
    //   int year = startDate.add(Duration(days: i)).year;

    //   // month
    //   int month = startDate.add(Duration(days: i)).month;

    //   // day
    //   int day = startDate.add(Duration(days: i)).day;

    //   // int rate = (db.differenceSum * 100).toInt();
    //   // rate = rate > 100 ? 100 : rate;
    //   // print("rate -> $rate");

    //   int rate = (strengthAsPercent).toInt();
    //   rate = rate > 10 ? 10 : rate;
    //   print("rate -> $rate");

    //   // db.heatMapDataSet[DateTime(year, month, day)] = rate;
    //   final percentForEachDay = <DateTime, int> {
    //     DateTime(year, month, day) : (rate).toInt()
    //   };
    //   // Controll the opacity of color
    //   // final percentForEachDay = <DateTime, int> {
    //   //   DateTime(year, month, day) : (strengthAsPercent).toInt()
    //   // };

    //   print("HeatMap Set -> ${DateTime.parse(yyyymmdd)}");
    //   // print("strengAsPercent ~! -> $percentForEachDay");
    //   // db.heatMapDataSet = newDifferenceSum.toString as Map<DateTime, int>;
    //   db.heatMapDataSet.addEntries(percentForEachDay.entries);
    //   print(db.heatMapDataSet);
    // }
  }

  // Save the target amount of today (Create - Object)
  void saveTargetAmount() {
    setState(() {
      db.targetSum = int.parse(_newTargetAmountController.text);
    });
    db.updateDatabase();

    _newTargetAmountController.clear();
    Navigator.of(context).pop();
  }

  // Delete from the list (Delete)
  void deleteExpand(int index) {
    setState(() {
      db.moneyList.removeAt(index);

      // Calculate the sum
      saveDifference(innerSum, '-');
    });
    db.updateDatabase();
  }

  // Close the Dialog Box
  void cancelDialogBox() {
    _newMoneyElementController.clear();
    Navigator.of(context).pop();
  }
}
