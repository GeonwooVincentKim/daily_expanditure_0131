import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DailyExpanditureTile extends StatelessWidget {
  final String moneyName;
  final Function(BuildContext)? deleteTapped;

  const DailyExpanditureTile({
    super.key, 
    required this.moneyName, 
    required this.deleteTapped
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // element of list 'daily money'
              Text(moneyName),
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
