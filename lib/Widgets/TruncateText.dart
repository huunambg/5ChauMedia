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

class TruncateText_Bold extends StatelessWidget {
  final String text;
  final double size;
  final int maxLength;
  TruncateText_Bold(this.text, {required this.maxLength, required this.size});
  @override
  Widget build(BuildContext context) {
    if (text.length <= maxLength) {
      return Text(text,style: TextStyle(fontWeight: FontWeight.bold,fontSize: size));
    } else {
      String truncatedText = text.substring(0, maxLength);
      return Text('$truncatedText...',style: TextStyle(fontWeight: FontWeight.bold,fontSize: size),);
    }
  }
}