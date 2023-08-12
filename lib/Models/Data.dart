import 'package:flutter/material.dart';

class Data_Provider extends ChangeNotifier{
  int _check_rolcall = 0;
  
  void set_check_rollcall (int res){
    _check_rolcall = res;
    notifyListeners();
  }
  int check_rolcall ()=>_check_rolcall;

}