import 'package:flutter/material.dart';

class Next_Screeen{
void pushReplacement(BuildContext context ,var Router){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Router));
}

void push(BuildContext context ,var Router){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>Router));
}
}