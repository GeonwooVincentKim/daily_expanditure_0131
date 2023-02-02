import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DailyExpanditureTile extends StatelessWidget {
  final int elementName;
  final bool elementIncluded;
  // final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const DailyExpanditureTile({
    super.key, 
    required this.elementName, 
    required this.elementIncluded,
    // required this.settingsTapped, 
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
            // delete option
            SlidableAction(
              onPressed: deleteTapped,
              backgroundColor: CupertinoColors.systemRed,
              icon: CupertinoIcons.delete,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // element of list 'daily money'
              Text('$elementName'),
              const SizedBox(width: 50),
              ElevatedButton(
                onPressed: () => false,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: CupertinoColors.quaternarySystemFill,
                  backgroundColor: Colors.transparent
                ),
                child: const Icon(Icons.arrow_back_ios, color: CupertinoColors.systemGrey),
              )
            ],
          ),
        ),
      )
    );
  }
}