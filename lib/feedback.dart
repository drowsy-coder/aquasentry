import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  void _submitFeedback() {
    setState(() {
      _isSubmitting = true;
    });

    // Simulate feedback submission with a delay
    Future.delayed(Duration(seconds: 2), () {
      String feedback = _feedbackController.text;

      // Process the feedback
      print('Feedback submitted: $feedback');

      // Reset the feedback text
      setState(() {
        _feedbackController.clear();
        _isSubmitting = false;
      });

      // Show a confirmation dialog or navigate back
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Feedback Submitted'),
            content: Text('Thank you for your feedback!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
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
      title: Text('User Feedback'),
    ),
    body: Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.feedback,
                size: 50,
                color: Color.fromRGBO(13, 206, 158, 1),
              ),
              SizedBox(width: 10),
              Text(
                'Your FEEDBACK matters',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
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
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _feedbackController,
                    decoration: InputDecoration(
                      hintText: 'your experience goes here....',
                      border: InputBorder.none,
                    ),
                    maxLines: 50,
                    style: TextStyle(fontSize: 22.0, height: 1.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SizedBox(height: 10),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitFeedback,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: _isSubmitting
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      'Submit',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
