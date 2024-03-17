
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hackathon1/contact.dart';
import 'package:flutter_hackathon1/feedback.dart';
import 'package:flutter_hackathon1/graph.dart';
import 'package:flutter_hackathon1/rate.dart';

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
        '/': (context) => ChlorineLevelScreen(),
        '/graph': (context) => GraphScreen(),
      },
    );
  }
}

// ... rest of the code for ChlorineLevelScreen ...

class ChlorineLevelScreen extends StatefulWidget {
  @override
  _ChlorineLevelScreenState createState() => _ChlorineLevelScreenState();
}

class _ChlorineLevelScreenState extends State<ChlorineLevelScreen> with SingleTickerProviderStateMixin {
  bool isDarkMode = false;

  late double _phValue;
  final DatabaseReference _phDataRef =
      FirebaseDatabase.instance.reference().child('ph_data').child('latest').child('pH');

  @override
  void initState() {
    super.initState();
    _phValue = 0.0; // Initialize pH value
    _phDataRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          _phValue = double.parse(event.snapshot.value.toString());
        });
      } else {
        print('Snapshot value is null');
      }
    }, onError: (error) {
      print('Error fetching pH value: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chlorine Monitor'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: FadeTransition(
            opacity: kAlwaysCompleteAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Live Chlorine Level:',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'pH Value: $_phValue',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/graph');
                        },
                        child: Text('View Graph'),
                      ),
                      SizedBox(height: 20),
                      Text(
                        ' (7.2) - (7.6): Perfect down to the last minute Atom\n(5) - (7.2) or (7.6) - (10): Itty bitty issue\n(< 5) or (> 10): I am the Danger',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
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
                  'Give Feedback',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedbackPage(), // Navigate to the FeedbackPage
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
