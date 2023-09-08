import 'package:flutter/material.dart';

class Permission_Provider extends ChangeNotifier{
  List<dynamic> _list_permisson=[];

void set_list_permission(var data){
_list_permisson =data;
notifyListeners();
}
List<dynamic>list_permisson()=>_list_permisson;
}