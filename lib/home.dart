
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hackathon1/contact.dart';
import 'package:flutter_hackathon1/feedback.dart';
import 'package:flutter_hackathon1/graph.dart';
import 'package:flutter_hackathon1/map.dart';
import 'package:flutter_hackathon1/rate.dart';
import 'package:intl/intl.dart';

class HomiePage extends StatefulWidget {
  static ThemeMode themeMode = ThemeMode.system;

  const HomiePage({super.key});

  static void updateThemeMode(ThemeMode mode) {
    themeMode = mode;
  }

  @override
  _HomiePageState createState() => _HomiePageState();

  static ThemeMode get currentThemeMode => themeMode;
}

class _HomiePageState extends State<HomiePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chlorine Level Monitor',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        hintColor: Colors.tealAccent,
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            color: Colors.black87,
            fontSize: 16.0,
          ),
          bodyText2: TextStyle(
            color: Colors.black87,
            fontSize: 14.0,
          ),
          headline6: TextStyle(
            color: Colors.teal,
            fontFamily: 'Roboto',
            fontSize: 20.0,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            color: Colors.white70,
            fontSize: 16.0,
          ),
          bodyText2: TextStyle(
            color: Colors.white70,
            fontSize: 14.0,
          ),
          headline6: TextStyle(
            color: Colors.tealAccent,
            fontFamily: 'Roboto',
            fontSize: 20.0,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: Colors.tealAccent),
      ),
      themeMode: HomiePage.currentThemeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => GarbageLevelScreen(),
        '/graph': (context) => GraphScreen(),
      },
    );
  }
}

class GarbageLevelScreen extends StatefulWidget {
  @override
  _GarbageLevelScreenState createState() => _GarbageLevelScreenState();
}

class _GarbageLevelScreenState extends State<GarbageLevelScreen> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref('gb_value/latest');

  Map<String, dynamic> garbageData = {};

  @override
  void initState() {
    super.initState();
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        garbageData = {
          "gb": data["gb"],
          "timestamp": data["timestamp"],
        };
      });
    });
  }

  String _formatTimestamp(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('yyyy-MM-dd – kk:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garbage Level Indicator', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Card(
          color: Colors.black,
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Garbage Level: ${garbageData["gb"] ?? "Loading..."}',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 10),
                Text(
                  'Last Updated: ${garbageData["timestamp"] != null ? _formatTimestamp(garbageData["timestamp"]) : "Loading..."}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    drawer: Drawer(
       child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 100, left: 50, bottom: 20),
                child: Text(
                  'User Feedback',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Icon(Icons.person, size: 80),
              ),
              ListTile(
                title: const Text(
                  'Map',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VITMap(), // Navigate to the FeedbackPage
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Rate Us',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RatePage(), // Navigate to the RatePage
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Contact Us',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactPage(), // Navigate to the ContactPage
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
