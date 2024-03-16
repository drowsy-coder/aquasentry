import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class GraphScreen extends StatefulWidget {
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  List<double> _chlorineLevels = [];
  late DatabaseReference _chlorineLevelsRef;

  @override
  void initState() {
    super.initState();

    Firebase.initializeApp(); // Initialize Firebase

    _chlorineLevelsRef = FirebaseDatabase.instance.reference().child('chlorineLevels');

    // Fetch initial data
    _chlorineLevelsRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
        List<double> newLevels = [];
        values.forEach((key, value) {
          double level = double.parse(value.toString());
          newLevels.add(level);
        });
        setState(() {
          _chlorineLevels = newLevels;
        });
      }
    }).catchError((error) {
      print('Error fetching initial data: $error');
    });

    // Listen for new data
    _chlorineLevelsRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        double level = double.parse(event.snapshot.value.toString());
        setState(() {
          _chlorineLevels.add(level);
        });
      }
    }, onError: (Object? error) {
      print('Error listening for new data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
backgroundColor: Color(0xFF070707),
title: Text(
'Chlorine Level Graph',
style: TextStyle(color: Colors.white),
),
iconTheme: IconThemeData(color: Colors.white),
),
body: Column(
children: [
Expanded(
child: Container(
padding: EdgeInsets.all(24.0),
decoration: BoxDecoration(
color: Colors.black,
borderRadius: BorderRadius.circular(10),
),
child: _chlorineLevels.isNotEmpty
? LineChart(
LineChartData(
lineBarsData: [
LineChartBarData(
spots: _groupData(_chlorineLevels),
isCurved: true,
colors: [Color.fromRGBO(13, 206, 158, 1)],
barWidth: 2,
isStrokeCapRound: true,
dotData: FlDotData(show: false),
belowBarData: BarAreaData(show: false),
),
],
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
    // Widget build code remains the same
  }

  List<FlSpot> _groupData(List<double> data) {
    return List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index]));
  }
}
