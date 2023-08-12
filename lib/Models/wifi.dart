
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
class Wifi_Provider extends ChangeNotifier{
  String _name ="Không có";

    NetworkInfo networkInfo = NetworkInfo();

  Future<void> setname(String ? res) async {
    if(res ==null && res !="Không có"){
    String? val =await networkInfo.getWifiName();
   _name = "Wifi $val";
    }else if(res !=null && res !="Không có"){
      _name = res;
    }else{
      _name = "Không có";
    }
   notifyListeners();
  }
 String getname()=> _name;

} 