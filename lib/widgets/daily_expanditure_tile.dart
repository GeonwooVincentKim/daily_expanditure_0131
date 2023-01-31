// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DailyExpanditureTile extends StatelessWidget {
  final String elementName;
  final bool elementIncluded;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const DailyExpanditureTile({
    super.key, 
    required this.elementName, 
    required this.elementIncluded,
    required this.settingsTapped, 
    required this.deleteTapped
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: settingsTapped,
              // backgroundColor: CupertinoColors.systemGrey3,
              // icon: CupertinoIcons.settings,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(12),
            ),

            // delete option
            SlidableAction(
              onPressed: deleteTapped,
              // backgroundColor: CupertinoColors.systemRed,
              // icon: CupertinoIcons.delete,
              backgroundColor: Colors.red.shade400,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            // color: CupertinoColors.systemGrey,
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // habit name
              Text(elementName),
            ],
          ),
        ),
      )
    );
  }
}