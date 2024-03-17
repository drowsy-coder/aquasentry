import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class GraphScreen extends StatefulWidget {
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  List<double> _chlorineLevels = [];
  late Timer _timer;
  int _selectedTimeRange = 1; // Default to one day
  final List<Map<String, dynamic>> _timeRanges = [
    {'label': '1 Min', 'value': 1},
    {'label': '1 Hour', 'value': 60},
    {'label': '12 Hours', 'value': 60 * 12},
    {'label': '1 Day', 'value': 60 * 24},
    {'label': '1 Month', 'value': 60 * 24 * 30},
    {'label': '6 Months', 'value': 60 * 24 * 30 * 6},
    {'label': '1 Year', 'value': 60 * 24 * 365},
  ];

  @override
  void initState() {
    super.initState();

    // Start generating random data every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Generate random chlorine level between 0 and 10
        _chlorineLevels.add(Random().nextDouble() * 10);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when disposing the widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Chlorine Level Graph', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: DropdownButton<int>(
              value: _selectedTimeRange,
              items: _timeRanges.map((timeRange) {
                return DropdownMenuItem<int>(
                  value: timeRange['value'],
                  child: Text(timeRange['label'],
                      style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTimeRange = value!;
                  _chlorineLevels.clear();
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24.0), // Increase padding on all sides
              decoration: BoxDecoration(
                color: Colors.black, // Set background color to black
                borderRadius: BorderRadius.circular(10),
              ),
              child: _chlorineLevels.isNotEmpty
                  ? LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: _groupData(_chlorineLevels),
                            isCurved: true,
                            colors: [Colors.lightBlue],
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          drawHorizontalLine: true,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey,
                              strokeWidth: 0.5,
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.grey,
                              strokeWidth: 0.5,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                            showTitles: true,
                            interval: (_selectedTimeRange / 5).toDouble(),
                            reservedSize: 22,
                            getTextStyles: (value) => TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            getTitles: (value) {
                              return _getBottomTitles(value.toInt());
                            },
                            margin: 8,
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            interval: 2,
                            getTextStyles: (value) => TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            getTitles: (value) {
                              return value.toInt().toString();
                            },
                            reservedSize: 28,
                            margin: 12,
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        minX: 0,
                        maxX: _chlorineLevels.length.toDouble() -
                            1, // Adjust maxX
                        minY: 0,
                      ),
                    )
                  : Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _getBottomTitles(int value) {
    if (_selectedTimeRange == 1) {
      return DateFormat('HH:mm').format(DateTime.now()
          .subtract(Duration(minutes: _selectedTimeRange - value)));
    } else {
      return DateFormat('MMM dd').format(
          DateTime.now().subtract(Duration(days: _selectedTimeRange - value)));
    }
  }

  List<FlSpot> _groupData(List<double> data) {
    if (_selectedTimeRange <= data.length) {
      // If the selected time range is less than or equal to the length of the data,
      // return the data without grouping
      return List.generate(
          data.length, (index) => FlSpot(index.toDouble(), data[index]));
    } else {
      // Perform the grouping process
      List<FlSpot> groupedData = [];
      int groupSize = (_chlorineLevels.length / _selectedTimeRange).ceil();
      for (int i = 0; i < _selectedTimeRange; i++) {
        double sum = 0;
        for (int j = i * groupSize;
            j < (i + 1) * groupSize && j < _chlorineLevels.length;
            j++) {
          sum += _chlorineLevels[j];
        }
        double average = sum / groupSize;
        groupedData.add(FlSpot(i.toDouble(), average));
      }
      return groupedData;
    }
  }
}