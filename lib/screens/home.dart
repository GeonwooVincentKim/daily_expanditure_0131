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
  List moneyList = [];

  final _newMoneyElementController = TextEditingController();

  int sum = 0;


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.grey[300],
      child: Column(
        children: [
          _widgetTargetAmount(),
          
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: moneyList.length,
              itemBuilder: (context, index) {
                return DailyExpanditureTile(
                  elementName: moneyList[index][0],
                  elementIncluded: moneyList[index][1],
                  settingsTapped: (context) => openExpandSettings(index),
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
                  // _widgetGoogleAds(context)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  CustomRow _widgetTargetAmount() {
    return CustomRow(
      children: [
        const SizedBox(width: 50),

        ElevatedButton(
          onPressed: () => false,
          child: const Text("Testing"),
        ),

        const SizedBox(width:35),
        GestureDetector(
          onTap: () {
            createNewExpanditure();
          },
          child: const CustomCircleAvatar(backgroundColor: transparentColor, icon: CupertinoIcons.creditcard, iconColor: buttonTextColor, size: 35),
        )
      ],
    );
  }

  CustomElevatedButton _widgetGoogleAds(BuildContext context) {
    // return ElevatedButton(
    //   style: ElevatedButton.styleFrom(
    //     elevation: 0,
    //     fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 60),
    //     backgroundColor: buttonColor,
    //     shadowColor: transparentColor,
    //   ).copyWith(
    //     overlayColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.pressed) ? null : buttonColor),
    //     elevation: const MaterialStatePropertyAll(0),
    //   ),
    //   child: const Text("Google Ads", style: TextStyle(color: buttonTextColor, fontSize: 25),),
    //   onPressed: () => false
    // );
    return CustomElevatedButton(getValue: "Google Ads", customFixedSize: Size(MediaQuery.of(context).size.width * 0.9, 60));
  }

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
            createNewExpanditure();
          },
          child: const CustomCircleAvatar(backgroundColor: swipeIconColor, icon: CupertinoIcons.plus, iconColor: plusIconColor, size: 35)
        )
      ],
    );
  }

  void createNewExpanditure() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialogBox(
          controller: _newMoneyElementController,
          hintText: "입력하세요",
          onSave: saveNewExpand,
          onCancel: cancelDialogBox,
        );
      }
    );
  }

  void openExpandSettings(int index) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialogBox(
          controller: _newMoneyElementController,
          hintText: moneyList[index][0],
          onSave: () => saveExistingExpand(index),
          onCancel: cancelDialogBox,
        );
      }
    );
  }

  void saveNewExpand() {
    setState(() {
      moneyList.add([_newMoneyElementController.text, false]);
    });

    _newMoneyElementController.clear();
    Navigator.of(context).pop();
  }

  void saveExistingExpand(int index) {
    setState(() {
      moneyList[index][0] = _newMoneyElementController.text;
      
      _newMoneyElementController.clear();
      Navigator.of(context).pop();
    });
  }

  void deleteExpand(int index) {
    setState(() {
      moneyList.removeAt(index);
    });
  }

  void cancelDialogBox() {
    _newMoneyElementController.clear();
    Navigator.of(context).pop();
  }
}

