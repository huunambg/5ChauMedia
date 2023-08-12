import 'package:flutter/material.dart';
import '/Models/settings.dart';
import 'package:provider/provider.dart';

class CustomTextDetail extends StatefulWidget {
  final String title;
  final String? desc;
  const CustomTextDetail({super.key, required this.title, this.desc});

  @override
  State<CustomTextDetail> createState() => _CustomTextDetailState();
}

class _CustomTextDetailState extends State<CustomTextDetail> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: 16,right: 16),
      height: height*0.06,
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromARGB(255, 189, 182, 182))),),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${widget.title}: ',
            style: TextStyle(
     
              fontSize: 18.0,
              color: context.watch<Setting_Provider>().text_color(),
            ),
          ),
         Text(
            widget.desc.toString(),
            style: TextStyle(
               fontWeight: FontWeight.bold,
              fontSize: 18.0,color: context.watch<Setting_Provider>().text_color()
            ),
          ),
        ],
      ),
    );
  }
}
