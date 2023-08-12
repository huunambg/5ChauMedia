import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:ionicons/ionicons.dart';
import '/Models/detailrollcall.dart';
import '/Widgets/appbar.dart';
import 'package:intl/intl.dart';
import '/Widgets/itemdetailrollcall.dart';
import 'package:provider/provider.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class ManamentRollCall_Screen extends StatefulWidget {
  const ManamentRollCall_Screen({super.key});

  @override
  State<ManamentRollCall_Screen> createState() =>
      _ManamentRollCall_ScreenState();
}

class _ManamentRollCall_ScreenState extends State<ManamentRollCall_Screen> {
  int? month, year;
  int currentMonth =
      int.parse(DateFormat('MM').format(DateTime.now()).toString());
  int currentYear =
      int.parse(DateFormat('yyyy').format(DateTime.now()).toString());
  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  List<Map<String, dynamic>> list_Data_Day_One_Day = [];
  void _loadSaved() async {
    await context
        .read<DetailRollCallUser_Provider>()
        .set_data_Rollcall_Current_Motnh(null, null);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(context),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            color: Color.fromARGB(255, 217, 228, 236),
            height: h * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      showMaterialDatePicker(
                        context: context,
                        title: 'Chọn thời gian',
                        firstDate: DateTime(2023,8),
                        lastDate: DateTime(2030),
                        selectedDate: DateTime.now(),
                        onChanged: (date) {
                          context
                              .read<DetailRollCallUser_Provider>()
                              .set_Data_Day_OneDay_Find(date);
                        },
                      );
                    },
                    icon: Icon(
                      Icons.calendar_month_outlined,
                    
                    )),
                Text("Tháng $currentMonth năm $currentYear"),
                IconButton(
                    onPressed: () {
                      showMonthPicker(context, onSelected: (month, year) {
                        if (kDebugMode) {
                          print('Chọn tháng: $month, year: $year');
                        }
                        setState(() {
                          this.month = month;
                          this.year = year;
                          currentMonth = month;
                          currentYear = year;
                        });
                        context
                            .read<DetailRollCallUser_Provider>()
                            .set_data_Rollcall_Current_Motnh(month, year);
                      },
                          initialSelectedMonth: month,
                          initialSelectedYear: year,
                          firstEnabledMonth: 8,
                          lastEnabledMonth: 10,
                          firstYear: 2023,
                          lastYear: 2030,
                          selectButtonText: 'OK',
                          cancelButtonText: 'Quay lại',
                          highlightColor: Color.fromARGB(255, 66, 142, 241),
                          textColor: Colors.black,
                          contentBackgroundColor: Colors.white,
                          dialogBackgroundColor: Colors.grey[200]);
                    },
                    icon: Icon(
                      Ionicons.chevron_down_outline,
                      color: Color.fromARGB(255, 102, 100, 100),
                    ))
              ],
            ),
          ),
          Expanded(
            child: Container(
                child: context
                            .watch<DetailRollCallUser_Provider>()
                            .count_day_int_month() !=
                        0
                    ? ListView.builder(
                        padding: EdgeInsets.fromLTRB(7, 0, 7, 7),
                        itemCount: context
                            .watch<DetailRollCallUser_Provider>()
                            .count_day_int_month(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.only(top: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0,
                                        3), // Điều chỉnh vị trí của bóng theo trục x và y
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(7),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15))),
                                    height: h * 0.06,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${Day_Format(context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]['day'].toString())}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${Rank_Format(context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]['rollcall_id'].toString(), context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]['day'].toString())}', //thứ
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${monthyear_Format(context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]['rollcall_id'].toString())}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]
                                              ['in1'] ==
                                          null
                                      ? Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text("Chưa điểm danh"))
                                      : context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]['in1'] != null &&
                                              context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]
                                                      ['out1'] !=
                                                  null &&
                                              context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]
                                                      ['in2'] ==
                                                  null
                                          ? Column(
                                              children: [
                                                Item_Detaill_Rollcall(
                                                    time: context
                                                            .watch<
                                                                DetailRollCallUser_Provider>()
                                                            .data_Rollcall_MonthYear()[
                                                        index]['in1'],
                                                    place: context
                                                            .watch<
                                                                DetailRollCallUser_Provider>()
                                                            .data_Rollcall_MonthYear()[
                                                        index]['place_in1']),
                                                Item_Detaill_Rollcall(
                                                    time: context
                                                            .watch<
                                                                DetailRollCallUser_Provider>()
                                                            .data_Rollcall_MonthYear()[
                                                        index]['out1'],
                                                    place: context
                                                            .watch<
                                                                DetailRollCallUser_Provider>()
                                                            .data_Rollcall_MonthYear()[
                                                        index]['place_out1'])
                                              ],
                                            )
                                          : context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]['in1'] != null &&
                                                  context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]
                                                          ['out1'] !=
                                                      null &&
                                                  context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]
                                                          ['in2'] !=
                                                      null &&
                                                  context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]
                                                          ['out2'] ==
                                                      null
                                              ? Column(
                                                  children: [
                                                    Item_Detaill_Rollcall(
                                                        time: context
                                                                .watch<
                                                                    DetailRollCallUser_Provider>()
                                                                .data_Rollcall_MonthYear()[
                                                            index]['in1'],
                                                        place: context
                                                                .watch<
                                                                    DetailRollCallUser_Provider>()
                                                                .data_Rollcall_MonthYear()[
                                                            index]['place_in1']),
                                                    Item_Detaill_Rollcall(
                                                        time: context
                                                                .watch<
                                                                    DetailRollCallUser_Provider>()
                                                                .data_Rollcall_MonthYear()[
                                                            index]['out1'],
                                                        place: context
                                                                .watch<
                                                                    DetailRollCallUser_Provider>()
                                                                .data_Rollcall_MonthYear()[
                                                            index]['place_out1']),
                                                    Item_Detaill_Rollcall(
                                                        time: context
                                                                .watch<
                                                                    DetailRollCallUser_Provider>()
                                                                .data_Rollcall_MonthYear()[
                                                            index]['in2'],
                                                        place: context
                                                                .watch<
                                                                    DetailRollCallUser_Provider>()
                                                                .data_Rollcall_MonthYear()[
                                                            index]['place_in2'])
                                                  ],
                                                )
                                              : context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]['in1'] != null &&
                                                      context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]
                                                              ['out1'] !=
                                                          null &&
                                                      context
                                                              .watch<DetailRollCallUser_Provider>()
                                                              .data_Rollcall_MonthYear()[index]['in2'] !=
                                                          null &&
                                                      context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]['out2'] != null
                                                  ? Column(
                                                      children: [
                                                        Item_Detaill_Rollcall(
                                                            time: context
                                                                    .watch<
                                                                        DetailRollCallUser_Provider>()
                                                                    .data_Rollcall_MonthYear()[
                                                                index]['in1'],
                                                            place: context
                                                                    .watch<
                                                                        DetailRollCallUser_Provider>()
                                                                    .data_Rollcall_MonthYear()[
                                                                index]['place_in1']),
                                                        Item_Detaill_Rollcall(
                                                            time: context
                                                                    .watch<
                                                                        DetailRollCallUser_Provider>()
                                                                    .data_Rollcall_MonthYear()[
                                                                index]['out1'],
                                                            place: context
                                                                    .watch<
                                                                        DetailRollCallUser_Provider>()
                                                                    .data_Rollcall_MonthYear()[
                                                                index]['place_out1']),
                                                        Item_Detaill_Rollcall(
                                                            time: context
                                                                    .watch<
                                                                        DetailRollCallUser_Provider>()
                                                                    .data_Rollcall_MonthYear()[
                                                                index]['in2'],
                                                            place: context
                                                                    .watch<
                                                                        DetailRollCallUser_Provider>()
                                                                    .data_Rollcall_MonthYear()[
                                                                index]['place_in2']),
                                                        Item_Detaill_Rollcall(
                                                            time: context
                                                                    .watch<
                                                                        DetailRollCallUser_Provider>()
                                                                    .data_Rollcall_MonthYear()[
                                                                index]['out2'],
                                                            place: context
                                                                    .watch<
                                                                        DetailRollCallUser_Provider>()
                                                                    .data_Rollcall_MonthYear()[
                                                                index]['place_out2'])
                                                      ],
                                                    )
                                                  : Item_Detaill_Rollcall(time: context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]['in1'], place: context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[index]['place_in1']),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      )),
          )
        ],
      ),
    ));
  }

  String Day_Format(String day) {
    int getday = int.parse(day);
    String day_format;
    if (getday < 10) {
      day_format = '0$getday';
    } else {
      day_format = "$day";
    }
    return day_format;
  }

  String monthyear_Format(String dateTime) {
    String formattedString =
        '${dateTime.substring(dateTime.length - 2)}/${dateTime.substring(0, 4)}';
    return formattedString;
  }

  String Rank_Format(String month_year, String day) {
    int getday = int.parse(day);
    String day_format;
    if (getday < 10) {
      day_format = '0$getday';
    } else {
      day_format = "$day";
    }

    String formattedString =
        '${month_year.substring(0, 4)}-${month_year.substring(month_year.length - 2)}';
    String res = "${formattedString}-$day_format";
    String thu = DateFormat("EEEE", 'vi_VN').format(DateTime.parse(res));
    return thu;
  }

  String Time_Format(DateTime dateTime) {
    String formattedDateTime = DateFormat("H:m:s").format(dateTime);
    return formattedDateTime;
  }
}
