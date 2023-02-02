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
  bool? hasSumValue; // Check sum value input first

  final _newMoneyElementController = TextEditingController();
  final _newTargetAmountController = TextEditingController();

  int innerSum = 0; // Calculate the sum of all elements of List (Expanditure)
  double differenceSum = 0.0; // get the value of `targetSum // (sum = moneyList)`
  int dailySum = 0; // get the value of `targetSum - (sum = moneyList)`

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.grey[300],
      child: Column(
        children: [
          _widgetTargetAmount(targetSum, true), // allows to set true input value anytime user wants
          
          // dummay variable to check the difference of targetSum and moneyList
          Text('$differenceSum', style: const TextStyle(color: CupertinoColors.black),),
          
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
          // Expanded(
            // child: Align(
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _widgetDailyOutlays(dailySum),
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
          hasSumValue: (textController == _newMoneyElementController && targetSum <= 0) ? false : true,
          onSave: onSave,
          onCancel: onCancel,
        );
      }
    );
  }

  // List of expanditure of today (Create - List)
  void saveNewExpand() {
    setState(() {
      moneyList.add([_newMoneyElementController.text, false]);
      // print(moneyList.runtimeType);

      print("length -> ${moneyList.length}");
      
      // Calculate the sum
      saveDifference(innerSum, '+');
    });

    if (hasSumValue == true) {
      _newMoneyElementController.clear();
    }
    Navigator.of(context).pop();
  }

  // Save the difference of TargetSum and moneyList
  void saveDifference(int innerSum, String sign) {
    // Not to set as String
    // This may cause type case error
    // Make sure parse the String value to Integer.
    for (int i = 0; i < moneyList.length; i++) {
      // print(moneyList[i][0].runtimeType); // Get current value's type
      print("Values -> ${int.parse(moneyList[i][0])}");
      // print("Plus -> ${int.parse(moneyList[i][0]) + int.parse(moneyList[i][0])}");
    
      if (sign == '+') {
        innerSum += int.parse(moneyList[i][0]); // Store into the innerSum
      } else if (sign == '-') {
        innerSum -= int.parse(moneyList[i][0]); // Store into the innerSum
      }
    }    
    
    // Get DailySum from innerSum
    dailySum = innerSum.abs();
    
    // If dailySum is less smaller than targetSum, divide innerSum by targetSum
    // Otherwise, divide dailySum by targetSum.
    if (dailySum <= targetSum) {
      differenceSum = double.parse((innerSum / targetSum).abs().toStringAsFixed(2));
    } else if (dailySum > targetSum) {
      differenceSum = double.parse((targetSum / innerSum).abs().toStringAsFixed(2));
    }

    print('Get SUM -> $differenceSum');
    print('Get Daily Sum -> ${innerSum.abs()}');
    
    if (innerSum.abs() < targetSum) {
      print("Difference -> ${(innerSum / targetSum).abs()}");
      print("Difference (2 digit) -> ${double.parse((innerSum / targetSum).abs().toStringAsFixed(2))}");
    } else if (innerSum.abs() > targetSum) {
      print("Difference -> ${(targetSum / innerSum).abs()}");
      print("Difference (2 digit) -> ${double.parse((targetSum / innerSum).abs().toStringAsFixed(2))}");
    }


    // If targetSum didn't input before input the value of innerSum,
    // return hasSumValue false
    // Otherwise return true
    if (targetSum == 0) {
      hasSumValue = false;
    } else {
      hasSumValue = true;
    }
  }

  // Save the target amount of today (Create - Object)
  void saveTargetAmount() {
    setState(() {
      targetSum = int.parse(_newTargetAmountController.text);
    });

    _newTargetAmountController.clear();
    Navigator.of(context).pop();
  }

  // Delete from the list (Delete)
  void deleteExpand(int index) {
    setState(() {
      moneyList.removeAt(index);

      // Calculate the sum
      saveDifference(innerSum, '-');
    });
  }

  // Close the Dialog Box
  void cancelDialogBox() {
    _newMoneyElementController.clear();
    Navigator.of(context).pop();
  }
}

