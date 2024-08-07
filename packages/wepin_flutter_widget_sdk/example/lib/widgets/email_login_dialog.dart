import 'package:flutter/material.dart';

class EmailLoginDialog extends StatefulWidget {
  final Function(String email, String password) onLogin;

  const EmailLoginDialog({super.key, required this.onLogin});

  @override
  EmailLoginDialogState createState() => EmailLoginDialogState();
}

class EmailLoginDialogState extends State<EmailLoginDialog> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Email Login'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) => email = value,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            onChanged: (value) => password = value,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onLogin(email, password);
            Navigator.of(context).pop();
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
