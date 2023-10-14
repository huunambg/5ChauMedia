import 'dart:async';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:personnel_5chaumedia/Screens/admin/listmac.dart';
import 'package:personnel_5chaumedia/Services/networks.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Example app for wifi_scan plugin.
class Set_Mac_Wifi extends StatefulWidget {
  /// Default constructor for [Set_Mac_Wifi] widget.
  const Set_Mac_Wifi({Key? key}) : super(key: key);

  @override
  State<Set_Mac_Wifi> createState() => _Set_Mac_WifiState();
}

class _Set_Mac_WifiState extends State<Set_Mac_Wifi> {
  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  NetworkInfo networkInfo = NetworkInfo();
  String? mac, name;
  final Connectivity _connectivity = Connectivity();

  final namecontroller = TextEditingController();

  final maccontroller = TextEditingController();

  Future<void> _enableLocation() async {
    // Check if location service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    // Check location permissions
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // Get location data (optional)
    _locationData = await location.getLocation();
  }

  @override
  void initState() {
    super.initState();
    load();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          title: const Text('Thiết lập MAC'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => List_MAC()));
                },
                icon: Icon(Icons.list_alt))
          ],
        ),
        body: mac != null && name != null
            ? Container(
                padding: EdgeInsets.all(7),
                child: Column(
                  children: [
                    TextField(
                      controller: namecontroller,
                      decoration: InputDecoration(
                          labelText: "Tên Wifi",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: maccontroller,
                      decoration: InputDecoration(
                          labelText: "Địa chỉ MAC",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      minWidth: 230,
                      color: Colors.green,
                      onPressed: () async {
                        bool check_click = false;
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "Wifi: ${namecontroller.text}",
                            ),
                            content: Text("MAC: ${maccontroller.text}"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Quay lại")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    check_click = true;
                                  },
                                  child: Text("Thêm"))
                            ],
                          ),
                        );
                        if (check_click == true) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? id_company =
                              await prefs.getString("company_id");
                          if (await NetworkRequest().add_MAC_WIFI(id_company,
                                  namecontroller.text, maccontroller.text) ==
                              "Success") {
                            CherryToast.success(
                                    title:
                                        Text("Thêm Wifi điểm danh thành công"))
                                .show(context);
                          } else {
                            CherryToast.error(
                                    title: Text("Thêm Wifi điểm danh thất bại"))
                                .show(context);
                          }
                        }
                      },
                      child: Text(
                        "Lưu Wifi",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Future<void> load() async {
    await _enableLocation();
    mac = await networkInfo.getWifiBSSID();
    name = await networkInfo.getWifiName();


    List<String> macParts = mac!.split(":");
    List<String> formattedMacParts = [];
    for (String part in macParts) {
      if (part.length == 1) {
        formattedMacParts.add("0$part");
      } else {
        formattedMacParts.add(part);
      }
    }

    String formattedMacAddress = formattedMacParts.join(":");
    String xau = name!;
    if (xau.startsWith('"')) {
      xau = xau.substring(1);
    }
    if (xau.endsWith('"')) {
      xau = xau.substring(0, xau.length - 1);
    }
    //print(xau);
    setState(() {
      namecontroller.text = xau;
      maccontroller.text = formattedMacAddress;
    });
  }

  // Hàm bắt sự kiện thay đổi trạng thái kết nối mạng
  void _updateConnectionStatus(ConnectivityResult result) {
    if (result.toString() == "ConnectivityResult.wifi") {
      load();
    } else if (result.toString() == "ConnectivityResult.mobile") {
      CherryToast.warning(
              title: Text(
                  "Bạn cần phải bật wifi để lấy thông tin Wifi đang kết nối"))
          .show(context);
      load();
    } else if (result.toString() == "ConnectivityResult.none") {
      load();
    }
  }
}
