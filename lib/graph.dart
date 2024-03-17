
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphScreen extends StatefulWidget {
  final double phValue;

  GraphScreen({required this.phValue});

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  List<FlSpot> dataPoints = [FlSpot(0, 0.0)]; // Store the data points for the chart

  @override
  Widget build(BuildContext context) {
    double xCoordinate = dataPoints.last.x + 1; // Increment x-coordinate
    dataPoints.add(FlSpot(xCoordinate, widget.phValue));

    return Scaffold(
      appBar: AppBar(
        title: Text('pH Value Chart'),
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













