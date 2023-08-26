import 'package:audioplayers/audioplayers.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_barcode_scanner/enum.dart';
import '/Models/datauser.dart';
import '/Models/detailrollcall.dart';
import '/Models/location.dart';
import '/Models/notification.dart';
import '/Models/settings.dart';
import '/Models/wifi.dart';
import '/Services/networks.dart';
import '/Widgets/appbar.dart';
import '/Widgets/buttonrollcall.dart';
import '/Widgets/detailhome.dart';
import '/Widgets/todayrollcall.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});
  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  String? id_per;
  String? current_address, Text_QR;
  int distance = 0;
  int meter = 0;
  AudioPlayer player = AudioPlayer();
  String? get_MAC_WIFI;
  bool mac_check = false;
  String? rollcall_time;
  int timecheck = 5;
  int time_delay = 0;
  bool check =true;
  @override
  void dispose() {
    super.dispose();
  }

  String? id_personnel, id_rollcall;
  NetworkRequest _networkRequest = new NetworkRequest();
  var data;
  int? working_day;
  int? total_working_day;
  int? leave_permission;
  int? leave_without_permission;
  int? time;
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    Statistical(null, null);
    get_data_current_day();
  }

  void getWifiInfo() async {
    NetworkInfo networkInfo = NetworkInfo();
    String? wifiBSSID = await networkInfo.getWifiBSSID();
    String? wifiName = await networkInfo.getWifiName();
    print('Wi-Fi BSSID: $wifiBSSID');
    print('Wi-Fi Name: $wifiName');
    CherryToast.success(title: Text("MAC :$wifiBSSID")).show(context);
  }

  Future<void> get_data_current_day() async {
    context.read<Wifi_Provider>().setname(null);
    context.read<Location_Provider>().set__curren_address();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id_personnel = prefs.getString('id_personnel')!;
    await context.read<DetailRollCallUser_Provider>().set_Data_Day_OneDay();
    context.read<Notification_Provider>().set_count_notification_not_checked();
    context.read<DetailRollCallUser_Provider>().set_break_time_rollcall();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.notification.request();
    if (status.isDenied) {
      print("Bạn phai cấp quyền vị trí");
    }
  }

  @override
  Widget build(BuildContext context) {
    //double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Color(context.watch<Setting_Provider>().background_color()),
        appBar: CustomAppBar(context),
        body: data != null
            ? ListView(
                children: [
                  CustomItemTodayRollCall(),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "5 Châu Media ",
                          style: TextStyle(color: Colors.blue, fontSize: 16)),
                      TextSpan(
                          text:
                              "chúc bạn 1 ngày làm việc vui vẻ mời bạn chấm công bằng khuôn mặt hoặc QR")
                    ])),
                  ),
                  CustomButtonRollcall(
                    ontapface: () async {
                      CherryToast.warning(title: Text("Đang update!"))
                          .show(context);
                      playBeepWarning();
                    },
                    ontapqr: () async {
                      if (context
                              .read<DetailRollCallUser_Provider>()
                              .Data_Day_One_Day()[0]['out2'] !=
                          null) {
                        CherryToast.warning(
                                title: Text("Bạn đã điểm danh hôm nay"))
                            .show(context);
                        playBeepWarning();
                      } else {
                        checking_dialog(h);
                        await getcalculateDistance();
                        await checkmac();
                        if (check){
                        if (mounted != false) Navigator.pop(context);
                        if (distance <= meter && mac_check == true) {
                          _scanQRCode();
                        } else if (mac_check == true && distance > meter) {
                          error_distance_dialog(h);
                        } else if (mac_check == false && distance <= meter) {
                          error_wifi_dialog(h);
                        } else if (mac_check == false && distance > meter) {
                          error_wifi_distance_dialog(h);
                        }
                        }
                        check = true;
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomDetailHome(
                      title: "Vị trí hiện tại:",
                      content:
                          context.watch<Location_Provider>().current_address(),
                      icon: Icons.place_outlined),
                  CustomDetailHome(
                      title: "Mạng hiện tại:",
                      content: context.watch<Wifi_Provider>().getname(),
                      icon: Ionicons.git_network_outline),
                  CustomDetailHome(
                      title: "Tổng số ngày đi làm:",
                      content:
                          total_working_day != null && total_working_day != 0
                              ? "${total_working_day}"
                              : "Chưa đi làm",
                      icon: Icons.check_box_outlined),
                  CustomDetailHome(
                      title: "Tổng số ngày nghỉ có phép:",
                      content: leave_permission != null
                          ? "$leave_permission"
                          : "Chưa đi làm",
                      icon: Icons.warning_amber_rounded),
                  CustomDetailHome(
                      title: "Tổng số ngày nghỉ không phép:",
                      content: leave_without_permission != null
                          ? "$leave_without_permission"
                          : "Chưa đi làm",
                      icon: Icons.warning_amber_rounded),
                  CustomDetailHome(
                      title: "Tổng số phút làm:",
                      content: time != null ? "$time" : "Chưa đi làm",
                      icon: Icons.list_alt_rounded),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future<void> Statistical(int? m, int? y) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id_per = prefs.getString('id_per');
    data = await _networkRequest.Statistical_By_Month(id_per);
    if (data != null && data != "Error") {
      working_day = data['working_day'];
      total_working_day = data['total_working_day'];
      leave_permission = data['leave_permission'];
      id_rollcall = data["rollcall_id"];
      time = data['total_working_time'];
      leave_without_permission = data['leave_without_permission'];
    } else {
      if (mounted) {
        CherryToast.warning(title: Text("Not Exists")).show(context);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<double> _calculateDistance() async {
    var data = await _networkRequest.getLocation();
    meter = data['meter'];
    double fixedLatitude = double.parse(data['latitude']); // kinh độ
    double fixedLongitude = double.parse(data['longitude']); // vĩ độ
    Position currentPosition = await Geolocator.getCurrentPosition();
    double distance = await Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      fixedLatitude,
      fixedLongitude,
    );
    return distance;
  }

  Future<void> getcalculateDistance() async {
    double _distance = await _calculateDistance();
    Text_QR = await _networkRequest.get_Text_QR_Rollcall();
    distance = _distance.round();
    print("Distance : $distance");
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> checkmac() async {
    mac_check = false;
    NetworkInfo networkInfo = NetworkInfo();
    get_MAC_WIFI = await networkInfo.getWifiBSSID();
    List<String> macParts = get_MAC_WIFI!.split(":");
    List<String> formattedMacParts = [];
    for (String part in macParts) {
      if (part.length == 1) {
        formattedMacParts.add("0$part");
      } else {
        formattedMacParts.add(part);
      }
    }
    String formattedMacAddress = formattedMacParts.join(":");
    print("GET MAC WIFI : ${get_MAC_WIFI}");
    List<dynamic> mac = await NetworkRequest().get_MAC_WIFI();
    mac.forEach((element) {
      if (formattedMacAddress == element['address']) {
        mac_check = true;
      }
    });
  }

  Future<void> _scanQRCode() async {
    var scanResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(
              scanType: ScanType.qr, cancelButtonText: "Thoát"),
        ));
    if (!mounted) return; 
    print("QR res :$scanResult");
    if (scanResult == Text_QR && mac_check == true) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Lottie.asset("assets/lottie/loadingrollcall.json"),
          );
        },
      );
      int time_delay = await get_caculator_time_rollcall();
      print("Time delay $time_delay");
      if (time_delay <= 0) {
        if (context.read<Location_Provider>().current_address().toString() !=
            "Chưa tìm thấy.") {
          String res = await _networkRequest.rollcall_personnel(
              id_per, context.read<Location_Provider>().current_address());
          Navigator.pop(context);
          if (res == "Successful Attendance") {
            CherryToast.success(
              title: Text("Điểm danh thành công"),
              toastDuration: Duration(seconds: 2),
            ).show(context);
            playBeepSucces();
            context.read<DetailRollCallUser_Provider>().set_Data_Day_OneDay();
          } else {
            CherryToast.error(title: Text("Bạn đã điểm danh hôm nay"))
                .show(context);
            playBeepError();
          }
        } else {
          Navigator.pop(context);
          CherryToast.error(title: Text("Chưa tìm được vị trí của bạn!"))
              .show(context);
          playBeepError();
        }
      } else if (time_delay > 0) {
        Navigator.pop(context);
        CherryToast.error(
          title: Text(
            "Bạn phải chờ $time_delay phút để điểm danh",
          ),
        ).show(context);
        playBeepError();
      }
    } else if (scanResult != Text_QR &&
        scanResult != "-1" &&
        mac_check == true) {
      CherryToast.warning(
        title: Text("Mã QR không hợp lệ !"),
        toastDuration: Duration(seconds: 2),
      ).show(context);
      playBeepError();
    }
  }

  void checking_dialog(double h) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Stack(
            children: [
              Container(
                  height: h * 0.4,
                  child: Column(
                    children: [
                      Lottie.asset("assets/lottie/checkinglocation.json"),
                      Text("Đang kiểm tra vị trí và Wifi của bạn.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15))
                    ],
                  )),
              Positioned(bottom: 0,right: 0 ,child: TextButton(onPressed: () {
                  Navigator.pop(context);
                  check = false;
                },child: Text("Thoát"),),
              )
            ],
          ),
        );
      },
    );
  }
  void error_distance_dialog(double h) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: h * 0.4,
            child: Column(
              children: [
                Lottie.asset("assets/lottie/sad.json"),
                Text("Bạn không ở vị trí của công ty",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Thoát'),
            ),
          ],
        );
      },
    );
  }

  void error_wifi_dialog(double h) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: h * 0.4,
            child: Column(
              children: [
                Lottie.asset("assets/lottie/wifierror.json"),
                Text("Wifi không hợp lệ!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Thoát'),
            ),
          ],
        );
      },
    );
  }

  void error_wifi_distance_dialog(double h) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: h * 0.4,
            child: Column(
              children: [
                Lottie.asset("assets/lottie/sad.json"),
                Text("Vị trí và wifi của bạn không hợp lệ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Thoát'),
            ),
          ],
        );
      },
    );
  }

  Future<int> get_caculator_time_rollcall() async {
    String last_rollcall = await NetworkRequest()
        .get_last_rollcall(context.read<DataUser_Provider>().id_personnel());
    print("Last rollcall: $last_rollcall");
    Duration difference =
        DateTime.now().difference(DateTime.parse(last_rollcall));
    print("Caculator last time: ${difference.inMinutes}");
    int time_calc = difference.inMinutes;
    int time_delay =
        context.read<DetailRollCallUser_Provider>().break_time_rollcall() -
            time_calc;
    return time_delay;
  }

  void playBeepSucces() async {
    await player.play(AssetSource("sounds/tb.mp3"));
  }

  void playBeepError() async {
    await player.play(AssetSource("sounds/error.mp3"));
  }

  void playBeepWarning() async {
    await player.play(AssetSource("sounds/warning.mp3"));
  }

  Future<void> loadSaved() async {
    String? base64_image = await NetworkRequest()
        .get_base64_img(context.read<DataUser_Provider>().id_per());
    context.read<DataUser_Provider>().set_base64_img(base64_image);
  }
}
