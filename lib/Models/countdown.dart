import 'dart:async';

import 'package:flutter/material.dart';

class CountDown_Provider extends ChangeNotifier{
  int _countdown =0;
 bool _check_countdown =false;
 void set_countdown(int c){
  _check_countdown =false;
  _countdown =c;
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (timer) {
          if (_countdown < 1) {
            _check_countdown=true;
            timer.cancel();
          } else {
            _countdown--;
          }
          notifyListeners();
        });
      }

  int countdown()=>_countdown;
  bool check_countdown()=>_check_countdown;
 } 

