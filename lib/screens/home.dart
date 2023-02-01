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

  final _newMoneyElementController = TextEditingController();
  final _newTargetAmountController = TextEditingController();

  int sum = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.grey[300],
      child: Column(
        children: [
          _widgetTargetAmount(targetSum),
          
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: moneyList.length,
              itemBuilder: (context, index) {
                return DailyExpanditureTile(
                  elementName: moneyList[index][0],
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
  CustomRow _widgetTargetAmount(int targetSum) {
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
    });

    _newMoneyElementController.clear();
    Navigator.of(context).pop();
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
    });
  }

  // Close the Dialog Box
  void cancelDialogBox() {
    _newMoneyElementController.clear();
    Navigator.of(context).pop();
  }
}

