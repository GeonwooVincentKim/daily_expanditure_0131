import 'package:daily_expanditure_0131/shared/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatmapSummary extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDate;

  const HeatmapSummary({super.key, this.datasets, required this.startDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      child: HeatMap(
        // startDate: createDateTimeObject(startDate),
        startDate: DateTime(nowDate.year, nowDate.month, 1),
        // endDate: DateTime.now().add(Duration(days: 0)),
        endDate: DateTime(nowDate.year, nowDate.month + 1, 0),
        datasets: datasets,
        colorMode: ColorMode.opacity,
        // defaultColor: Colors.grey[200],
        // textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Color.fromARGB(50, 2, 179, 8),
        },
      )
    );
  }
}
