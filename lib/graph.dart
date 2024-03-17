import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class GraphScreen extends StatefulWidget {
@override
_GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
List<FlSpot> dataPoints = [];

@override
void initState() {
super.initState();
generateRandomData();
}

void generateRandomData() {
Random random = Random();
for (int i = 1; i <= 10; i++) {
double randomValue = random.nextDouble() * 13 + 1; // Generate random pH value between 1 and 14
dataPoints.add(FlSpot(i.toDouble(), randomValue));
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Random pH Value Chart'),
),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: LineChart(
LineChartData(
lineBarsData: [
LineChartBarData(
spots: dataPoints,
isCurved: true,
colors: [Colors.blue],
barWidth: 4,
isStrokeCapRound: true,
dotData: FlDotData(show: false),
),
],
titlesData: FlTitlesData(show: false),
borderData: FlBorderData(show: false),
lineTouchData: LineTouchData(enabled: false),
),
swapAnimationDuration: Duration(milliseconds: 500), // Animation duration
swapAnimationCurve: Curves.linear, // Animation curve
),
),
);
}
}