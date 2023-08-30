import 'package:flutter/material.dart';
import '/Services/networks.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailRollCallUser_Provider extends ChangeNotifier {
  var _Data_Day_One_Day;
  var _data_Rollcall_Month_Year;
  int _count_day_int_month = 0;
  String _id_per = "";
  int _break_time_rollcall = 0;
  int currentMonth =
      int.parse(DateFormat('MM').format(DateTime.now()).toString());
  int currentYear =
      int.parse(DateFormat('yyyy').format(DateTime.now()).toString());
  String currentDay = "${DateFormat('dd').format(DateTime.now())}";
  Future<void> set_Data_Day_OneDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id_personnel = prefs.getString('id_personnel')!;
    _Data_Day_One_Day = await NetworkRequest()
        .getdataRollcall_detail_day_one_day(
            "${currentYear}0$currentMonth", id_personnel, currentDay);
    //print(_Data_Day_One_Day);
    notifyListeners();
  }

  Data_Day_One_Day() => _Data_Day_One_Day;

  void set_id_per() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _id_per = prefs.getString('id_per')!;
    notifyListeners();
  }

  Future<void> set_data_Rollcall_Current_Motnh(int? month, int? year) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id_per = prefs.getString('id_per');
    if (month == null && year == null) {
      _data_Rollcall_Month_Year =
          await NetworkRequest().Detaill_Rollcall_By_Month(id_per);
    } else {
      _data_Rollcall_Month_Year = await NetworkRequest()
          .Detail_Rollcall_By_Month_Year(id_per, month, year);
    }
    int month2 =
        int.parse(_data_Rollcall_Month_Year[1]['rollcall_id'].substring(4));
    int year2 =
        int.parse(_data_Rollcall_Month_Year[1]['rollcall_id'].substring(0, 4));
    _count_day_int_month = DateTime(year2, month2 + 1, 0).day;
    // print(_count_day_int_month);
    notifyListeners();
  }

 Future <void> set_Data_Day_OneDay_Find(DateTime dateTime) async {
    String day = DateFormat("dd").format(dateTime);
    String month = DateFormat("MM").format(dateTime);
    String year = DateFormat("yy").format(dateTime);
    _count_day_int_month = 1;
    print("$day $month $year");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id_personnel = prefs.getString('id_personnel')!;
    _data_Rollcall_Month_Year = await NetworkRequest()
        .getdataRollcall_detail_day_one_day("20$year$month", id_personnel, day);
    print("data $_data_Rollcall_Month_Year");
    notifyListeners();
  }

  void set_break_time_rollcall(String id) async {
    _break_time_rollcall = await NetworkRequest().get_break_time(id);
    notifyListeners();
  }

  int break_time_rollcall() => _break_time_rollcall;
  String id_per() => _id_per;
  data_Rollcall_MonthYear() => _data_Rollcall_Month_Year;
  count_day_int_month() => _count_day_int_month;
}
