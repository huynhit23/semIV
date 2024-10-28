import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String Notification = "Information sent, Please check your Gmail";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fill in your information below:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(labelText: 'Message'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'VPlease enter your message';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendEmail();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$Notification')),
                    );
                  }
                },
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendEmail() async {
    final String username = "manhk5528@gmail.com";
    final String password = "zdlxlkekuuxadwxa";
    final String name = _nameController.text;
    final String mess = _messageController.text;
    final String userGmail = _emailController.text;
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Admin Urban Harmony')
      ..recipients.add(_emailController.text) // Địa chỉ người nhận
      ..subject = 'Confirm Response'
      ..text = 'Gmail Confirm Response'
      ..html =
          "<h1>Hello $name</h1>\n<p>We have received your message:</p>\n<p>'$mess'</p>\n<p>We will respond to $userGmail in the near future</p>";

    try {
      final sendReport = await send(message, smtpServer);

      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n${e.toString()}');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
        if (p.code == '550' || p.msg.contains('User unknown')) {
          debugPrint('Email does not exist!');
        }
      }
      Notification = "Gmail is incorrect,Please check your Gmail again";
    }
  }
}
