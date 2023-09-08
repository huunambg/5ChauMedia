import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '/Models/detailrollcall.dart';
import '/Widgets/appbar.dart';
import 'package:intl/intl.dart';
import '/Widgets/itemdetailrollcall.dart';
import 'package:provider/provider.dart';

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
  int currentDay =
      int.parse(DateFormat('dd').format(DateTime.now()).toString());
  bool checkseeCurrenday = true;
  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  int _startdate = 0;
  int _enddate = 0;
  int count_between = 0;
  bool checkbetween = false;

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
                _buildCalendarDialogButton(),
                Text("Tháng $currentMonth năm $currentYear"),
                Icon(
                  Ionicons.chevron_down_outline,
                  color: Color.fromARGB(255, 102, 100, 100),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
                child:
                    context
                                .watch<DetailRollCallUser_Provider>()
                                .count_day_int_month() !=
                            0
                        ? ListView.builder(
                            padding: EdgeInsets.fromLTRB(7, 0, 7, 7),
                            itemCount: checkseeCurrenday == true &&
                                    checkbetween == false
                                ? currentDay
                                : checkseeCurrenday == false &&
                                        checkbetween == false
                                    ? context
                                        .watch<DetailRollCallUser_Provider>()
                                        .count_day_int_month()
                                    : count_between + 1,
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
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15))),
                                        height: h * 0.06,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${Day_Format(context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false ? currentDay - index - 1 : checkseeCurrenday == false && checkbetween == false ? index : _enddate - index - 1]['day'].toString())}',
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
                                                  '${Rank_Format(context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false ? currentDay - index - 1 : checkseeCurrenday == false && checkbetween == false ? index : _enddate - index - 1]['rollcall_id'].toString(), context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false ? currentDay - index - 1 : checkseeCurrenday == false && checkbetween == false ? index : _enddate - index - 1]['day'].toString())}', //thứ
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${monthyear_Format(context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false ? currentDay - index - 1 : checkseeCurrenday == false && checkbetween == false ? index : _enddate - index - 1]['rollcall_id'].toString())}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[
                                                  checkseeCurrenday == true &&
                                                          checkbetween == false
                                                      ? currentDay - index - 1
                                                      : checkseeCurrenday == false &&
                                                              checkbetween ==
                                                                  false
                                                          ? index
                                                          : _enddate -
                                                              index -
                                                              1]['in1'] ==
                                              null
                                          ? Container(
                                              padding: EdgeInsets.all(5),
                                              child: Text("Chưa điểm danh"))
                                          : context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday ==
                                                                  true &&
                                                              checkbetween ==
                                                                  false
                                                          ? currentDay -
                                                              index -
                                                              1
                                                          : checkseeCurrenday ==
                                                                      false &&
                                                                  checkbetween ==
                                                                      false
                                                              ? index
                                                              : _enddate -
                                                                  index -
                                                                  1]['in1'] !=
                                                      null &&
                                                  context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[
                                                          checkseeCurrenday ==
                                                                      true &&
                                                                  checkbetween ==
                                                                      false
                                                              ? currentDay - index - 1
                                                              : checkseeCurrenday == false && checkbetween == false
                                                                  ? index
                                                                  : _enddate - index - 1]['out1'] !=
                                                      null &&
                                                  context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false
                                                          ? currentDay - index - 1
                                                          : checkseeCurrenday == false && checkbetween == false
                                                              ? index
                                                              : _enddate - index - 1]['in2'] ==
                                                      null
                                              ? Column(
                                                  children: [
                                                    Item_Detaill_Rollcall(
                                                        time: context
                                                            .watch<
                                                                DetailRollCallUser_Provider>()
                                                            .data_Rollcall_MonthYear()[checkseeCurrenday ==
                                                                    true &&
                                                                checkbetween ==
                                                                    false
                                                            ? currentDay -
                                                                index -
                                                                1
                                                            : checkseeCurrenday ==
                                                                        false &&
                                                                    checkbetween ==
                                                                        false
                                                                ? index
                                                                : _enddate -
                                                                    index -
                                                                    1]['in1'],
                                                        place: context
                                                            .watch<
                                                                DetailRollCallUser_Provider>()
                                                            .data_Rollcall_MonthYear()[checkseeCurrenday ==
                                                                    true &&
                                                                checkbetween == false
                                                            ? currentDay - index - 1
                                                            : checkseeCurrenday == false && checkbetween == false
                                                                ? index
                                                                : _enddate - index - 1]['place_in1']),
                                                    Item_Detaill_Rollcall(
                                                        time: context
                                                            .watch<
                                                                DetailRollCallUser_Provider>()
                                                            .data_Rollcall_MonthYear()[checkseeCurrenday ==
                                                                    true &&
                                                                checkbetween == false
                                                            ? currentDay - index - 1
                                                            : checkseeCurrenday == false && checkbetween == false
                                                                ? index
                                                                : _enddate - index - 1]['out1'],
                                                        place: context
                                                            .watch<
                                                                DetailRollCallUser_Provider>()
                                                            .data_Rollcall_MonthYear()[checkseeCurrenday == true &&
                                                                checkbetween ==
                                                                    false
                                                            ? currentDay -
                                                                index -
                                                                1
                                                            : checkseeCurrenday == false &&
                                                                    checkbetween ==
                                                                        false
                                                                ? index
                                                                : _enddate -
                                                                    index -
                                                                    1]['place_out1'])
                                                  ],
                                                )
                                              : context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false
                                                              ? currentDay - index - 1
                                                              : checkseeCurrenday == false && checkbetween == false
                                                                  ? index
                                                                  : _enddate - index - 1]['in1'] !=
                                                          null &&
                                                      context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false
                                                              ? currentDay - index - 1
                                                              : checkseeCurrenday == false && checkbetween == false
                                                                  ? index
                                                                  : _enddate - index - 1]['out1'] !=
                                                          null &&
                                                      context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false
                                                              ? currentDay - index - 1
                                                              : checkseeCurrenday == false && checkbetween == false
                                                                  ? index
                                                                  : _enddate - index - 1]['in2'] !=
                                                          null &&
                                                      context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false
                                                              ? currentDay - index - 1
                                                              : checkseeCurrenday == false && checkbetween == false
                                                                  ? index
                                                                  : _enddate - index - 1]['out2'] ==
                                                          null
                                                  ? Column(
                                                      children: [
                                                        Item_Detaill_Rollcall(
                                                            time: context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true &&
                                                                        checkbetween ==
                                                                            false
                                                                    ? currentDay -
                                                                        index -
                                                                        1
                                                                    : checkseeCurrenday == false &&
                                                                            checkbetween ==
                                                                                false
                                                                        ? index
                                                                        : _enddate - index - 1]
                                                                ['in1'],
                                                            place: context
                                                                .watch<
                                                                    DetailRollCallUser_Provider>()
                                                                .data_Rollcall_MonthYear()[checkseeCurrenday ==
                                                                        true &&
                                                                    checkbetween ==
                                                                        false
                                                                ? currentDay -
                                                                    index -
                                                                    1
                                                                : checkseeCurrenday == false &&
                                                                        checkbetween ==
                                                                            false
                                                                    ? index
                                                                    : _enddate -
                                                                        index -
                                                                        1]['place_in1']),
                                                        Item_Detaill_Rollcall(
                                                            time: context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true &&
                                                                        checkbetween ==
                                                                            false
                                                                    ? currentDay -
                                                                        index -
                                                                        1
                                                                    : checkseeCurrenday == false &&
                                                                            checkbetween ==
                                                                                false
                                                                        ? index
                                                                        : _enddate - index - 1]
                                                                ['out1'],
                                                            place: context
                                                                .watch<
                                                                    DetailRollCallUser_Provider>()
                                                                .data_Rollcall_MonthYear()[checkseeCurrenday ==
                                                                        true &&
                                                                    checkbetween ==
                                                                        false
                                                                ? currentDay -
                                                                    index -
                                                                    1
                                                                : checkseeCurrenday == false &&
                                                                        checkbetween ==
                                                                            false
                                                                    ? index
                                                                    : _enddate -
                                                                        index -
                                                                        1]['place_out1']),
                                                        Item_Detaill_Rollcall(
                                                            time: context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true &&
                                                                        checkbetween ==
                                                                            false
                                                                    ? currentDay -
                                                                        index -
                                                                        1
                                                                    : checkseeCurrenday == false &&
                                                                            checkbetween ==
                                                                                false
                                                                        ? index
                                                                        : _enddate - index - 1]
                                                                ['in2'],
                                                            place: context
                                                                .watch<
                                                                    DetailRollCallUser_Provider>()
                                                                .data_Rollcall_MonthYear()[checkseeCurrenday ==
                                                                        true &&
                                                                    checkbetween ==
                                                                        false
                                                                ? currentDay -
                                                                    index -
                                                                    1
                                                                : checkseeCurrenday == false &&
                                                                        checkbetween ==
                                                                            false
                                                                    ? index
                                                                    : _enddate -
                                                                        index -
                                                                        1]['place_in2'])
                                                      ],
                                                    )
                                                  : context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false
                                                                  ? currentDay - index - 1
                                                                  : checkseeCurrenday == false && checkbetween == false
                                                                      ? index
                                                                      : _enddate - index - 1]['in1'] !=
                                                              null &&
                                                          context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false
                                                                  ? currentDay - index - 1
                                                                  : checkseeCurrenday == false && checkbetween == false
                                                                      ? index
                                                                      : _enddate - index - 1]['out1'] !=
                                                              null &&
                                                          context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false
                                                                  ? currentDay - index - 1
                                                                  : checkseeCurrenday == false && checkbetween == false
                                                                      ? index
                                                                      : _enddate - index - 1]['in2'] !=
                                                              null &&
                                                          context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false
                                                                  ? currentDay - index - 1
                                                                  : checkseeCurrenday == false && checkbetween == false
                                                                      ? index
                                                                      : _enddate - index - 1]['out2'] !=
                                                              null
                                                      ? Column(
                                                          children: [
                                                            Item_Detaill_Rollcall(
                                                                time: context
                                                                    .watch<
                                                                        DetailRollCallUser_Provider>()
                                                                    .data_Rollcall_MonthYear()[checkseeCurrenday ==
                                                                            true &&
                                                                        checkbetween ==
                                                                            false
                                                                    ? currentDay -
                                                                        index -
                                                                        1
                                                                    : checkseeCurrenday ==
                                                                                false &&
                                                                            checkbetween ==
                                                                                false
                                                                        ? index
                                                                        : _enddate -
                                                                            index -
                                                                            1]['in1'],
                                                                place: context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false
                                                                    ? currentDay - index - 1
                                                                    : checkseeCurrenday == false && checkbetween == false
                                                                        ? index
                                                                        : _enddate - index - 1]['place_in1']),
                                                            Item_Detaill_Rollcall(
                                                                time: context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true &&
                                                                            checkbetween ==
                                                                                false
                                                                        ? currentDay -
                                                                            index -
                                                                            1
                                                                        : checkseeCurrenday == false &&
                                                                                checkbetween ==
                                                                                    false
                                                                            ? index
                                                                            : _enddate - index - 1]
                                                                    ['out1'],
                                                                place: context
                                                                    .watch<
                                                                        DetailRollCallUser_Provider>()
                                                                    .data_Rollcall_MonthYear()[checkseeCurrenday ==
                                                                            true &&
                                                                        checkbetween ==
                                                                            false
                                                                    ? currentDay -
                                                                        index -
                                                                        1
                                                                    : checkseeCurrenday == false &&
                                                                            checkbetween ==
                                                                                false
                                                                        ? index
                                                                        : _enddate -
                                                                            index -
                                                                            1]['place_out1']),
                                                            Item_Detaill_Rollcall(
                                                                time: context
                                                                    .watch<
                                                                        DetailRollCallUser_Provider>()
                                                                    .data_Rollcall_MonthYear()[checkseeCurrenday ==
                                                                            true &&
                                                                        checkbetween ==
                                                                            false
                                                                    ? currentDay -
                                                                        index -
                                                                        1
                                                                    : checkseeCurrenday ==
                                                                                false &&
                                                                            checkbetween ==
                                                                                false
                                                                        ? index
                                                                        : _enddate -
                                                                            index -
                                                                            1]['in2'],
                                                                place: context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false
                                                                    ? currentDay - index - 1
                                                                    : checkseeCurrenday == false && checkbetween == false
                                                                        ? index
                                                                        : _enddate - index - 1]['place_in2']),
                                                            Item_Detaill_Rollcall(
                                                                time: context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true &&
                                                                            checkbetween ==
                                                                                false
                                                                        ? currentDay -
                                                                            index -
                                                                            1
                                                                        : checkseeCurrenday == false &&
                                                                                checkbetween ==
                                                                                    false
                                                                            ? index
                                                                            : _enddate - index - 1]
                                                                    ['out2'],
                                                                place: context
                                                                    .watch<
                                                                        DetailRollCallUser_Provider>()
                                                                    .data_Rollcall_MonthYear()[checkseeCurrenday ==
                                                                            true &&
                                                                        checkbetween ==
                                                                            false
                                                                    ? currentDay -
                                                                        index -
                                                                        1
                                                                    : checkseeCurrenday == false &&
                                                                            checkbetween ==
                                                                                false
                                                                        ? index
                                                                        : _enddate -
                                                                            index -
                                                                            1]['place_out2'])
                                                          ],
                                                        )
                                                      : Item_Detaill_Rollcall(
                                                          time: context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false
                                                              ? currentDay - index - 1
                                                              : checkseeCurrenday == false && checkbetween == false
                                                                  ? index
                                                                  : _enddate - index - 1]['in1'],
                                                          place: context.watch<DetailRollCallUser_Provider>().data_Rollcall_MonthYear()[checkseeCurrenday == true && checkbetween == false
                                                              ? currentDay - index - 1
                                                              : checkseeCurrenday == false && checkbetween == false
                                                                  ? index
                                                                  : _enddate - index - 1]['place_in1']),
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

  List<DateTime?> _dialogCalendarPickerValue = [DateTime.now(), DateTime.now()];
  Future<String> _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) async {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        String? startDate = values[0].toString().replaceAll('00:00:00.000', '');
        String? endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';

        if (startDate != "null" && endDate == "null") {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Center(child: CircularProgressIndicator())),
              );
            },
          );
          await context
              .read<DetailRollCallUser_Provider>()
              .set_Data_Day_OneDay_Find(DateTime.parse(startDate.trim()));
          Navigator.pop(context);
          int start_month = int.parse(
              DateFormat('MM').format(DateTime.parse(startDate.trim())));
          int start_year = 2000 +
              int.parse(
                  DateFormat('yy').format(DateTime.parse(startDate.trim())));
          checkbetween = false;
          checkseeCurrenday = false;
          setState(() {
            currentMonth = start_month;
            currentYear = start_year;
          });
        } else {
          int end_month = int.parse(
              DateFormat('MM').format(DateTime.parse(endDate.trim())));
          int end_year = 2000 +
              int.parse(
                  DateFormat('yy').format(DateTime.parse(endDate.trim())));
          int start_month = int.parse(
              DateFormat('MM').format(DateTime.parse(startDate.trim())));
          int start_year = 2000 +
              int.parse(
                  DateFormat('yy').format(DateTime.parse(startDate.trim())));
          if (end_month == start_month && end_year == start_year) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Center(child: CircularProgressIndicator())),
                );
              },
            );
            _startdate = int.parse(
                DateFormat('dd').format(DateTime.parse(startDate.trim())));
            int temp_endate = int.parse(
                DateFormat('dd').format(DateTime.parse(endDate.trim())));
            if (temp_endate <
                    int.parse(DateFormat('dd').format(DateTime.now())) ||
                start_month >
                    int.parse(DateFormat('MM').format(DateTime.now()))) {
              _enddate = temp_endate;
            } else {
              _enddate = int.parse(DateFormat('dd').format(DateTime.now()));
            }
            await context
                .read<DetailRollCallUser_Provider>()
                .set_data_Rollcall_Current_Motnh(start_month, start_year);
            Navigator.pop(context);
            count_between = _enddate - _startdate;
            checkbetween = true;
            checkseeCurrenday = false;
            setState(() {
              currentMonth = start_month;
              currentYear = start_year;
            });
          } else {
            CherryToast.warning(
                    title: Text("Bạn chỉ được chọn trong phạm vi trong tháng"))
                .show(context);
          }
        }
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  _buildCalendarDialogButton() {
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      firstDate: DateTime(2023, 9),
      lastDate: DateTime(2030),
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return IconButton(
      onPressed: () async {
        final values = await showCalendarDatePicker2Dialog(
          context: context,
          config: config,
          dialogSize: const Size(325, 400),
          borderRadius: BorderRadius.circular(15),
          value: _dialogCalendarPickerValue,
          dialogBackgroundColor: Colors.white,
        );
        if (values != null) {
          // ignore: avoid_print
          print(_getValueText(
            config.calendarType,
            values,
          ));
          setState(() {
            _dialogCalendarPickerValue = values;
          });
        }
      },
      icon: Icon(Icons.calendar_month),
    );
  }
}
