import 'package:flutter/cupertino.dart';

const Map<int, Color> customColorSet = {
  1: Color.fromARGB(20, 2, 179, 8),
  // 2: Color.fromARGB(40, 2, 179, 8),
  // 3: Color.fromARGB(60, 2, 179, 8),
  // 4: Color.fromARGB(80, 2, 179, 8),
  // 5: Color.fromARGB(100, 2, 179, 8),
  // 6: Color.fromARGB(120, 2, 179, 8),
  // 7: Color.fromARGB(160, 2, 179, 8),
  // 8: Color.fromARGB(180, 2, 179, 8),
  // 9: Color.fromARGB(220, 2, 179, 8),
  // 10: Color.fromARGB(255, 2, 179, 8)
};

// Get Background Colors
const Color backgroundColor = Color.fromRGBO(189, 183, 183, 100);

// Get Button Colors
const Color buttonColor = Color.fromRGBO(217, 217, 217, 100);
const Color swipeIconColor = Color.fromRGBO(126, 126, 126, 100);
const Color plusIconColor = Color.fromRGBO(82, 82, 82, 100);

const Color transparentColor = Color.fromRGBO(255, 255, 255, 0);

const Color buttonTextColor = Color.fromARGB(255, 0, 0, 0);

// Get Button Border
const List<double> buttonBorder = [0, 10, 20, 30, 40, 50];

// Get padding between Buttons
const List<double> verticalList = [5, 10, 20, 30, 40, 50];
EdgeInsets verticalBigPadding = EdgeInsets.symmetric(vertical: verticalList[3]);
EdgeInsets verticalNormalPadding = EdgeInsets.symmetric(vertical: verticalList[1]);
EdgeInsets verticalSmallPadding = EdgeInsets.symmetric(vertical: verticalList[0]);

// Get ElevatedButton Box Size
const fixedTargetAmount = Size(130, 30);
const fixedDailyOutlays = Size(130, 40);

// Text Style
const sumTextStyle = TextStyle(color: buttonTextColor, fontSize: 25);
