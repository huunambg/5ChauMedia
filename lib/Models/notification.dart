import 'package:flutter/material.dart';
import '/Services/networks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notification_Provider extends ChangeNotifier{
 int _check_exist_Notification_visted =0;
 String _id_personnel="";
  Future<void> set_id_personnel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _id_personnel = prefs.getString('id_personnel')!;
    notifyListeners();
  }
  String id_personnel()=> _id_personnel; 
Future<void> set_count_notification_not_checked(String id)async{
 _check_exist_Notification_visted =await NetworkRequest().get_count_notification_not_check(id);
 notifyListeners();
}
int check_exist_Notification_visted(){
  return _check_exist_Notification_visted;
}


}