import 'package:flutter/material.dart';
import '/Models/detailrollcall.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CustomItemTodayRollCall extends StatelessWidget {
  const CustomItemTodayRollCall({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(5),
      height: h * 0.18,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            height: h * 0.14,

            decoration: BoxDecoration(color: Colors.white,
         boxShadow: [ BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3), // Điều chỉnh vị trí của bóng theo trục x và y
      ),],
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(15)),
          ),
          Positioned(
            top: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 5, 0),
              height: h * 0.03,
              width: w * 0.85,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 56, 121, 233),
                  borderRadius: BorderRadius.circular(7)),
              child: Row(children: [
                Icon(
                  Icons.calendar_month,
                  size: 15,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Thông tin điểm danh hôm nay",
                  style: TextStyle(color: Colors.white),
                )
              ]),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                context.watch<DetailRollCallUser_Provider>().Data_Day_One_Day() !=null ?
                Text(
                  "Điểm danh lần 1: ${context.watch<DetailRollCallUser_Provider>().Data_Day_One_Day()[0]['in1'] != null ? convertDateAndTime(context.watch<DetailRollCallUser_Provider>().Data_Day_One_Day()[0]['in1']) : "Chưa điểm danh"}\nĐiểm danh lần 2: ${context.watch<DetailRollCallUser_Provider>().Data_Day_One_Day()[0]['out1'] != null ? convertDateAndTime(context.watch<DetailRollCallUser_Provider>().Data_Day_One_Day()[0]['out1']) : "Chưa điểm danh"}\nĐiểm danh lần 3: ${context.watch<DetailRollCallUser_Provider>().Data_Day_One_Day()[0]['in2'] != null ? convertDateAndTime(context.watch<DetailRollCallUser_Provider>().Data_Day_One_Day()[0]['in2']) : "Chưa điểm danh"}\nĐiểm danh lần 4: ${context.watch<DetailRollCallUser_Provider>().Data_Day_One_Day()[0]['out2'] != null ? convertDateAndTime(context.watch<DetailRollCallUser_Provider>().Data_Day_One_Day()[0]['out2']) : "Chưa điểm danh"}",
                  style: TextStyle(color: Colors.blue),
                ):Text("Chưa điểm danh"),
              ],
            ),
          )
        ],
      ),
    );
  }

  String convertDateAndTime(String inputDateTime) {
    // Định dạng đầu vào 'yyMMdd h:m:s'
    DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dateTime = inputFormat.parse(inputDateTime);
    // Định dạng đầu ra 'h:m:i dd/MM/yy'
    DateFormat outputFormat = DateFormat('H:m:s dd/MM/yy');
    String formattedDateTime = outputFormat.format(dateTime);

    return formattedDateTime;
  }
}
