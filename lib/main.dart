import 'package:daily_expanditure_0131/model/custom_daily_money.dart';
import 'package:daily_expanditure_0131/model/custom_money.dart';
import 'package:daily_expanditure_0131/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  // Hive.registerAdapter(CustomMoneyAdapter());
  Hive.registerAdapter(CustomDailyMoneyAdapter());
  await Hive.openBox<CustomMoney>('money'); // It could be not work
  await Hive.openBox<CustomDailyMoney>("daily_money");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: HomePage(),
    );
  }
}
