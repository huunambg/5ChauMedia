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
              "Công ty ${context.watch<DataUser_Provider>().company_name()} - ${context.watch<DataUser_Provider>().department_name()}",
              style: TextStyle(
                  fontSize: 13, color: Color.fromARGB(255, 110, 107, 107)),
            )
          ],
        ),
      );
}
