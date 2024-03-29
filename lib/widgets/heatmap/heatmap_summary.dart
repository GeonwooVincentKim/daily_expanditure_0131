import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatmapSummary extends StatelessWidget {
  final Map<DateTime, int> datasets;
  // final String startDate;

  // const HeatmapSummary({super.key, required this.datasets, required this.startDate});
  const HeatmapSummary({super.key, required this.datasets});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: HeatMap(
        // startDate: createDateTimeObject(startDate),
        startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
        endDate: DateTime.now().add(Duration(days: 40)),
        // endDate: DateTime(nowDate.year, nowDate.month + 1, 0),
        datasets: datasets,
        colorMode: ColorMode.color,
        // defaultColor: Colors.grey[200],
        // textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 28,
        colorsets: const {
          1: Color.fromARGB(20, 2, 179, 8),
          2: Color.fromARGB(40, 2, 179, 8),
          3: Color.fromARGB(60, 2, 179, 8),
          4: Color.fromARGB(80, 2, 179, 8),
          5: Color.fromARGB(100, 2, 179, 8),
          6: Color.fromARGB(120, 2, 179, 8),
          7: Color.fromARGB(150, 2, 179, 8),
          8: Color.fromARGB(180, 2, 179, 8),
          9: Color.fromARGB(220, 2, 179, 8),
          10: Color.fromARGB(255, 2, 179, 8),
        },
      )
    );
  }
}
