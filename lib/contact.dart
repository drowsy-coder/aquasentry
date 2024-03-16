import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Color.fromRGBO(13, 206, 158, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildContactOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Contact Us',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(13, 206, 158, 1),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'We are here to assist you.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildContactOptions(BuildContext context) {
    return Column(
      children: [
        _buildContactOption(
          context,
          icon: Icons.email,
          label: 'Email',
          
          onPressed: () => _sendEmail(context),
        ),
        SizedBox(height: 20),
        _buildContactOption(
          context,
          icon: Icons.phone,
          label: 'Call Us',
          onPressed: () => _makeCall(context),
        ),
      ],
    );
  }

  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: Color.fromRGBO(13, 206, 158, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 36,
              color: Colors.black,
            ),
            SizedBox(width: 20),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendEmail(BuildContext context) {
    // Implement email sending functionality here
    print('Sending email...');
    // Example: Launch email app or navigate to email sending page
  }

  void _makeCall(BuildContext context) {
    // Implement call functionality here
    print('Making a call...');
    // Example: Launch phone app or make a phone call
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ContactPage(),
  ));
}
