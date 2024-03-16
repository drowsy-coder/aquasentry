import 'package:flutter/material.dart';

class RatePage extends StatefulWidget {
  const RatePage({Key? key}) : super(key: key);

  @override
  _RatePageState createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  double _rating = 0.0;
  bool _isSubmitting = false;
  Color getButtonColor(double rating) {
    if (rating == 0) {
      return Color.fromRGBO(13, 206, 158, 1);
    } else {
      if (rating < 2) {
        return Colors.red;
      } else if (rating < 4) {
        return Colors.yellow;
      } else if (rating < 5) {
        return Colors.green;
      } else {
        return Colors.blue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        title: const Text('Rate Us'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(bottom: 200, top: 200, left: 20, right: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(71, 5, 5, 5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Rate your Experience',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Light text color
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _rating == 0
                        ? Icon(
                            Icons.roller_skating_rounded,
                            size: 64,
                          )
                        : _rating == 5
                            ? Icon(
                                Icons.sentiment_very_satisfied_rounded,
                                size: 64,
                                color: Colors.blue,
                              )
                            : _rating >= 4
                                ? Icon(
                                    Icons.sentiment_satisfied_rounded,
                                    size: 64,
                                    color: Colors.green,
                                  )
                                : _rating >= 2
                                    ? Icon(
                                        Icons.sentiment_neutral_rounded,
                                        size: 64,
                                        color: Colors.amber,
                                      )
                                    : Icon(
                                        Icons.sentiment_dissatisfied_rounded,
                                        size: 64,
                                        color: Colors.red,
                                      ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Slider(
                value: _rating,
                min: 0,
                max: 5,
                divisions: 10,
                label: _rating.toString(),
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRating,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: getButtonColor(_rating),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Submit Rating',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 221, 216, 202)),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRating() {
    setState(() {
      _isSubmitting = true;
    });

    // Simulate rating submission with a delay
    Future.delayed(const Duration(seconds: 2), () {
      print('User rated: $_rating');

      setState(() {
        _isSubmitting = false;
      });

      // Show a confirmation dialog or navigate back
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Rating Submitted'),
            content: const Text('Thank you for your feedback!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }
}
