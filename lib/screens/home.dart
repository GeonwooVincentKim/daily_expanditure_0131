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
  int targetSum = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.grey[300],
      child: Column(
        children: [
          _widgetTargetAmount(db.targetSum, true), // allows to set true input value anytime user wants
          
          // dummay variable to check the difference of targetSum and moneyList
          Text('${db.targetSum}', style: const TextStyle(color: CupertinoColors.black),),
          // HeatmapSummary(datasets: db.heatMapDataSet, startDate: _myBox.get("START_DATE")),
          HeatmapSummary(datasets: db.heatMapDataSet),

          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: db.moneyList.length,
              itemBuilder: (context, index) {
                return DailyExpanditureTile(
                  moneyName: db.moneyList[index][0],
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

      saveDifference(innerSum, '+');
      _myBox.put("INNER_SUM", innerSum);
    });

    _newMoneyElementController.clear();

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
  }

  // Save the target amount of today (Create - Object)
  void saveTargetAmount() {
    setState(() {
      db.targetSum = int.parse(_newTargetAmountController.text);
      _myBox.put("TARGET_SUM", targetSum);
    });
    db.updateDatabase();

    _newTargetAmountController.clear();
    Navigator.of(context).pop();
  }

  // Delete from the list (Delete)
  void deleteExpand(int index) {
    setState(() {
      db.moneyList.removeAt(index);
      saveDifference(innerSum, "-");

      _myBox.put("INNER_SUM", innerSum);
    });
    db.updateDatabase();
  }

  // Close the Dialog Box
  void cancelDialogBox() {
    _newMoneyElementController.clear();
    Navigator.of(context).pop();
  }
}
