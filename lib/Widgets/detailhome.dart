import 'package:flutter/material.dart';

import 'TruncateText.dart';

class CustomDetailHome extends StatelessWidget {
  const CustomDetailHome(
      {super.key,
      required this.title,
      required this.content,
      required this.icon});
  final String title;
  final String content;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(8),
      height: h * 0.08,
      width: w,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Điều chỉnh vị trí của bóng theo trục x và y
          ),
        ],
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color.fromARGB(255, 207, 205, 205),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 25,
          ),
          SizedBox(
            width: w * 0.01,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text("$title",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),), TruncateText("$content", maxLength: 40)],
          )
        ],
      ),
    );
  }
}
