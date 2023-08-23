import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataUser_Provider extends ChangeNotifier{
  String _id_personnel ="";
  String _id_per ="";
  String _name_personnel ="";
  String _base64_img = "";
  String _email ="";
  String _phone ="";
  String _base64_img_edit = "";
 Future<void> set_id_name_personnel()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _id_personnel = prefs.getString('id_personnel')!;
    _name_personnel = prefs.getString("user_name")!;
    _id_per = prefs.getString('id_per')!;
    _email = prefs.getString('email')!;
    _phone = prefs.getString('phone')!;
    notifyListeners();
 }
 
 void set_base64_img(String img){
  _base64_img = img;
    notifyListeners();
 }

 void set_base64_img_edit(String img){
  _base64_img_edit = img;
    notifyListeners();
 }

 String base64_img()=>_base64_img;
 String base64_img_edit()=>_base64_img_edit;
 String id_personnel()=>_id_personnel;
  String name_personnel()=>_name_personnel;
  String id_per()=>_id_per;
    String email()=>_email;
      String phone()=>_phone;
}