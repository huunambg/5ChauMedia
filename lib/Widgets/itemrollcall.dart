// import 'package:flutter/material.dart';
// import 'package:ndialog/ndialog.dart';
// import '/Services/networks.dart';
// import 'package:intl/intl.dart';
// import '/constants.dart';

// class CustomItemRollcall extends StatefulWidget {
//   final String? day;
//   final String? check;
//   final String? id_per;
//   final String? rollcall_id;
//   const CustomItemRollcall(
//       {super.key, this.day, this.check, this.id_per, this.rollcall_id});

//   @override
//   State<CustomItemRollcall> createState() => _CustomItemRollcallState();
// }

// class _CustomItemRollcallState extends State<CustomItemRollcall> {
//   NetworkRequest _networkRequest = NetworkRequest();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       width: 70,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Color.fromARGB(255, 190, 186, 186).withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 8,
//               offset: Offset(0, 4),
//             ),
//           ],
//           gradient: LinearGradient(
//             colors: widget.check == null
//                 ? not_rollcall
//                 : widget.check == "p"
//                     ? leave_permission_color
//                     : widget.check == 'k'
//                         ? leave_without_permission_color
//                         : widget.check == 'v'
//                             ? v_color
//                             : not_rollcall,
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Color.fromARGB(255, 158, 149, 149))),
//       child: MaterialButton(
//         onPressed: () async {
//           var data = await _networkRequest.getdataRollcall_detail_day_one_day(
//               widget.rollcall_id, widget.id_per, widget.day);
//           NDialog(
//             dialogStyle: DialogStyle(titleDivider: true,backgroundColor: theme_color),
//             title: Text("Ngày: ${widget.day}"),
//             content: data['in1'] != null
//                 ? Text(
//                     "Điểm danh lần 1: ${data['in1'] != null ? convertDateAndTime(data['in1']) : "Chưa điểm danh"}\nĐiểm danh lần 2: ${data['out1'] != null ? convertDateAndTime(data['out1']) : "Chưa điểm danh"}\nĐiểm danh lần 3: ${data['in2'] != null ? convertDateAndTime(data['in2']) : "Chưa điểm danh"}\nĐiểm danh lần 4: ${data['out2'] != null ? convertDateAndTime(data['out2']) : "Chưa điểm danh"} \nSố lần điểm danh: ${data['total']} \nThời gian làm: ${data['time']!=null ? data['time'] : 0} phút")
//                 : Text("Bạn chưa điểm danh ngày hôm này "),
//             actions: <Widget>[
//               TextButton(
//                   child: Text("Thoát"),
//                   onPressed: () => Navigator.pop(context)),
//             ],
//           ).show(context);
//         },
//         child: Text("${widget.day}"),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   String convertDateAndTime(String inputDateTime) {
//     // Định dạng đầu vào 'yyMMdd h:m:s'
//     DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     DateTime dateTime = inputFormat.parse(inputDateTime);
//     // Định dạng đầu ra 'h:m:i dd/MM/yy'
//     DateFormat outputFormat = DateFormat('H:m:s dd/MM/yy');
//     String formattedDateTime = outputFormat.format(dateTime);

//     return formattedDateTime;
//   }
// }
