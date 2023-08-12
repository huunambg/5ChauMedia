import 'package:flutter/material.dart';

class Setting_Provider extends ChangeNotifier{
  int _background_color = 0xFFFFFFF;
  Color _textcolor = Colors.black;
  void set_background_color(bool check){
    if(check == false){
      _background_color = 0xFFFFFFF;
      _textcolor =Colors.black;
    }
    else{
       _background_color = 0xDD000000;
        _textcolor =Colors.white;
    }
    notifyListeners();
  }
   int background_color()=>_background_color;
  
  Color text_color()=>_textcolor;
}