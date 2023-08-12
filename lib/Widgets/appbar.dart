import 'package:flutter/material.dart';
import '/Models/datauser.dart';
import 'package:provider/provider.dart';

AppBar CustomAppBar(BuildContext context) {
     double h = MediaQuery.of(context).size.height;
  return AppBar(
        toolbarHeight: h * 0.1,
        leading: Container(
            padding: EdgeInsets.all(5),
            child: Image.asset("assets/qr_code_scan.png")),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${context.watch<DataUser_Provider>().name_personnel()}"),
            Text(
              "Nhân viên chính thức - Công ty 5 Châu Media",
              style: TextStyle(
                  fontSize: 13, color: Color.fromARGB(255, 110, 107, 107)),
            )
          ],
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         showMonthPicker(context, onSelected: (month, year) {
        //           if (kDebugMode) {
        //             print('Chọn tháng: $month, year: $year');
        //           }
        //           setState(() {
        //             this.month = month;
        //             this.year = year;
        //           });
        //           Statistical(this.month, this.year);
        //         },
        //             initialSelectedMonth: month,
        //             initialSelectedYear: year,
        //             firstEnabledMonth: 8,
        //             lastEnabledMonth: 10,
        //             firstYear: 2023,
        //             lastYear: 2030,
        //             selectButtonText: 'OK',
        //             cancelButtonText: 'Quay lại',
        //             highlightColor: Colors.purple,
        //             textColor: Colors.black,
        //             contentBackgroundColor: Colors.white,
        //             dialogBackgroundColor: Colors.grey[200]);
        //       },
        //       icon: Icon(
        //         Ionicons.calendar_outline,
        //         size: 30,
        //       )),
        // ],
      );
}
