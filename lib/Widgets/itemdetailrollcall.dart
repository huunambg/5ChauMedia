import 'dart:convert';

import 'package:flutter/material.dart';
import '/Models/datauser.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'TruncateText.dart';
class Item_Detaill_Rollcall extends StatelessWidget {
  const Item_Detaill_Rollcall({super.key, required this.time, required this.place});
  final String? time;
  final String? place;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: 2, right: 7),
      margin: EdgeInsets.only(top: h * 0.01),
      color: Color.fromARGB(255, 226, 222, 222),
      height: h * 0.1,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(500),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500),
                color: Colors.white,
              ),
              height: h * 0.075,
              width: h * 0.075,
              child: context.read<DataUser_Provider>().base64_img() !="Error" && context.read<DataUser_Provider>().base64_img()!= "" ? Image(image: MemoryImage(base64Decode(context.watch<DataUser_Provider>().base64_img())),fit: BoxFit.cover,): Image.asset("assets/images/qr_scanner.png",fit: BoxFit.cover,),
            ),
          ),
          SizedBox(width: 5,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Tên : ${context.watch<DataUser_Provider>().name_personnel()}"),
              Text(
                "Lúc : ${time != null ? Time_Format(DateTime.parse(time!)) : "chưa điểm danh"}",
                style: TextStyle(fontSize: 12),
              ),
              TruncateText(
                "Tại : ${place != null ? place : "chưa điểm danh"}",
                maxLength: 32,
              )
            ],
          )
        ],
      ),
    );
  }
      String Time_Format(DateTime dateTime) {
    String formattedDateTime = DateFormat("H:m:s").format(dateTime);
    return formattedDateTime;
  }
}
