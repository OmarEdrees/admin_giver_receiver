import 'package:admin_giver_receiver/logic/services/colors_app.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartData lineChartData() {
  return LineChartData(
    gridData: FlGridData(show: false),
    titlesData: FlTitlesData(show: false),
    borderData: FlBorderData(show: false),

    lineBarsData: [
      LineChartBarData(
        spots: const [
          FlSpot(0, 1.9),
          FlSpot(1, 2.5),
          FlSpot(2, 2.3),
          FlSpot(3, 2.8),
          FlSpot(4, 2.4),
          FlSpot(5, 2.9),
        ],
        isCurved: true,
        color: Colors.white,
        barWidth: 1,
        dotData: FlDotData(
          show: true,
          checkToShowDot: (spot, barData) {
            return spot.x == 3; // رقم النقطة يلي بدك ياها
          },
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 4.5,
              color: AppColors().primaryColor,
              strokeWidth: 4,
              strokeColor: Colors.white,
            );
          },
        ),

        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.06),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ],
  );
}
