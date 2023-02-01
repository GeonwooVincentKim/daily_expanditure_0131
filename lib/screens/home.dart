import 'package:daily_expanditure_0131/shared/style.dart';
import 'package:daily_expanditure_0131/widgets/custom/column_row/custom_row.dart';
import 'package:daily_expanditure_0131/widgets/custom/custom_alert_dialog_box.dart';
import 'package:daily_expanditure_0131/widgets/custom/custom_circle_avatar.dart';
import 'package:daily_expanditure_0131/widgets/custom/custom_elevated_button.dart';
import 'package:daily_expanditure_0131/widgets/daily_expanditure_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List moneyList = []; // list of money that user spend for a day
  int targetSum = 0; // target sum of money that user planned to use for a day
  bool hasSumValue = false; // Check sum value input first

  final _newMoneyElementController = TextEditingController();
  final _newTargetAmountController = TextEditingController();

  int sum = 0; // get the value of `targetSum - (sum = moneyList)`

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.grey[300],
      child: Column(
        children: [
          _widgetTargetAmount(targetSum, hasSumValue),
          
          // dummay variable to check the difference of targetSum and moneyList
          Text('$sum', style: const TextStyle(color: CupertinoColors.black),),
          
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: moneyList.length,
              itemBuilder: (context, index) {
                return DailyExpanditureTile(
                  elementName: int.parse(moneyList[index][0]),
                  elementIncluded: moneyList[index][1],
                  // settingsTapped: (context) => openExpandSettings(index),
                  deleteTapped: (context) => deleteExpand(index),
                );
              },
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _widgetDailyOutlays(),
                  CustomElevatedButton(getValue: "Google Ads", customFixedSize: Size(MediaQuery.of(context).size.width * 0.9, 60))
                ],
              ),
            ),
          )
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
  CustomRow _widgetDailyOutlays() {
    return CustomRow(
      children: [
        const Text("Testing 1"),
        const SizedBox(width: 20),

        ElevatedButton(
          onPressed: () => false,
          child: const Text("Testing"),
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
  void createNewExpanditure(TextEditingController textController, onSave, onCancel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialogBox(
          controller: textController,
          hintText: "입력하세요",
          hasSumValue: false,
          onSave: onSave,
          onCancel: onCancel,
        );
      }
    );
  }

  // List of expanditure of today (Create - List)
  void saveNewExpand() {
    int innerSum = 0; // Calculate the sum of all elements of List (Expanditure)

    setState(() {
      moneyList.add([_newMoneyElementController.text, false]);
      // print(moneyList.runtimeType);

      print("length -> ${moneyList.length}");
      
      // Calculate the sum
      saveDifference(innerSum);
    });

    _newMoneyElementController.clear();
    Navigator.of(context).pop();
  }

  // Save the difference of TargetSum and moneyList
  bool saveDifference(int innerSum) {
    // Not to set as String
    // This may cause type case error
    // Make sure parse the String value to Integer.
    for (int i = 0; i < moneyList.length; i++) {
      // print(moneyList[i][0].runtimeType); // Get current value's type
      print("Values -> ${int.parse(moneyList[i][0])}");
      print("Plus -> ${int.parse(moneyList[i][0]) + int.parse(moneyList[i][0])}");
    
      innerSum += int.parse(moneyList[i][0]); // Store into the innerSum
    }
    
    if (targetSum > innerSum) {
      hasSumValue = true;
      sum = (targetSum - innerSum).abs();
    } else if (targetSum < innerSum) {
      hasSumValue = false;
    }
     
    return hasSumValue;
    // If element 
    // if (innerSum < sum) {
    // } else {
    //   sum = (innerSum - targetSum).abs();
    // }
  }

  // Save the target amount of today (Create - Object)
  void saveTargetAmount() {
    setState(() {
      targetSum = int.parse(_newTargetAmountController.text);
    });

    _newTargetAmountController.clear();
    Navigator.of(context).pop();
  }

  // Save the difference of TargetSum and moneyList
  // void saveDifference() {
  //   setState(() {
  //     // Make sure parse the String value to Integer.
  //     for (int i = 0; i < moneyList.length; i++) {
  //       // print(moneyList[i][0].runtimeType); // Get current value's type
  //       sum += int.parse(moneyList[i][0]);
  //     }

  //     sum = targetSum - sum;
  //   });
  // }

  // Delete from the list (Delete)
  void deleteExpand(int index) {
    setState(() {
      moneyList.removeAt(index);
    });
  }

  // Close the Dialog Box
  void cancelDialogBox() {
    _newMoneyElementController.clear();
    Navigator.of(context).pop();
  }
}

