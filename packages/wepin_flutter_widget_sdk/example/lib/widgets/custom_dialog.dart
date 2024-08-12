import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final String message;
  final bool isError; // 에러 여부를 나타내는 플래그

  const CustomDialog({
    Key? key,
    this.title,
    required this.message,
    this.isError = false, // 기본값은 false로 설정
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.info_outline,
            color: isError ? Colors.red : Colors.blue,
          ),
          const SizedBox(width: 8),
          Text(
            title ?? (isError ? 'Error' : 'Information'),
            style: TextStyle(
              color: isError ? Colors.red : Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
