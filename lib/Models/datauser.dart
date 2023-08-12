import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataUser_Provider extends ChangeNotifier{
  String _id_personnel ="";
  String _id_per ="";
  String _name_personnel ="";

 void set_id_name_personnel()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
    _id_personnel = prefs.getString('id_personnel')!;
    _name_personnel = prefs.getString("user_name")!;
    _id_per = prefs.getString('id_per')!;
    notifyListeners();
 }
 

 String id_personnel()=>_id_personnel;
  String name_personnel()=>_name_personnel;
  String id_per()=>_id_per;
}