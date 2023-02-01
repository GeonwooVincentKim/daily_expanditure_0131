import 'package:daily_expanditure_0131/shared/style.dart';
import 'package:daily_expanditure_0131/widgets/custom_alert_dialog_box.dart';
import 'package:daily_expanditure_0131/widgets/daily_expanditure_tile.dart';
import 'package:daily_expanditure_0131/widgets/my_floating_action_button.dart';
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

  void createNewExpanditure() {
    // showCupertinoDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return CustomAlertDialogBox(
    //       controller: _newMoneyElementController,
    //       hintText: "입력하세요",
    //       onSave: saveNewExpand,
    //       onCancel: cancelDialogBox,
    //     );
    //   }
    // );
    showDialog(
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(224, 224, 224, 1),
      // floatingActionButton: MyFloatingActionButton(onPressed: createNewExpanditure),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Testing 1"),
                      ElevatedButton(
                        onPressed: () => false,
                        child: Text("Testing"),
                      ),
                      GestureDetector(
                        onTap: () {
                          createNewExpanditure();
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: buttonColor,
                          child: ClipOval(
                            child: Icon(CupertinoIcons.plus, color: plusIconColor, size: 35)
                          ),
                        )
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Testing 2")
                    ],
                  )
                ],
              )
              
            ],
          ),
        ],
      ),
    );
  }

  void saveNewExpand() {
    setState(() {
      moneyList.add([_newMoneyElementController.text, false]);
    });

    _newMoneyElementController.clear();

    Navigator.of(context).pop();
  }

  void cancelDialogBox() {
    _newMoneyElementController.clear();
    
    Navigator.of(context).pop();
  }

  void openExpandSettings(int index) {
    showDialog(
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
}
