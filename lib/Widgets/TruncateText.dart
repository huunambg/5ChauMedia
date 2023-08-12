import 'package:flutter/material.dart';

class TruncateText extends StatelessWidget {
  final String text;
  final int maxLength;

  TruncateText(this.text, {required this.maxLength});

  @override
  Widget build(BuildContext context) {
    if (text.length <= maxLength) {
      return Text(text);
    } else {
      String truncatedText = text.substring(0, maxLength);
      return Text('$truncatedText...');
    }
  }
}