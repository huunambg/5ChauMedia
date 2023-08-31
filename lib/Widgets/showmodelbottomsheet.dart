import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CusstomshowModalBottomSheet extends StatefulWidget {
  const CusstomshowModalBottomSheet({super.key, required this.images, required this.title, required this.content, required this.time});
  final String images;
    final String title;
      final String content;
      final String time;
  @override
  State<CusstomshowModalBottomSheet> createState() =>
      _CusstomshowModalBottomSheetChiTietState();
}

class _CusstomshowModalBottomSheetChiTietState
    extends State<CusstomshowModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: h * 0.55,
          child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Color.fromARGB(66, 218, 203, 203)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(  color: Color.fromARGB(255, 223, 220, 220),image: DecorationImage(image: AssetImage("${widget.images}"),fit: BoxFit.cover)),
                        height: h * 0.167,
                        width: w * 0.3,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Ionicons.close_outline),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: h * 0.35,
                  child: ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15, right: 30),
                        height: h * 0.07,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color.fromARGB(66, 218, 203, 203)))),
                        child: Text("Thời gian: ${widget.time}"),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15, right: 30),
                        height: h * 0.08,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color.fromARGB(66, 218, 203, 203)))),
                        child: Text("Tiêu đề: ${widget.title}",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 7, left: 15, right: 30),
                          child: Text(
                              "Nội dung: ${widget.content}")),
                    ],
                  ),
                ),
              ])),
        )
      ],
    );
  }
}
