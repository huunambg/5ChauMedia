// import 'dart:async';
// import 'dart:io';
// import 'package:cherry_toast/cherry_toast.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import '/Models/detailrollcall.dart';
// import '/Models/location.dart';
// import '/Services/networks.dart';
// import 'package:provider/provider.dart';
// import '_code_scanner/qr_code_scanner.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:android_flutter_wifi/android_flutter_wifi.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// class Rollcall_Personnel_Scanner extends StatefulWidget {
//   const Rollcall_Personnel_Scanner({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _Rollcall_Personnel_ScannerState();
// }

// class _Rollcall_Personnel_ScannerState
//     extends State<Rollcall_Personnel_Scanner> {
//   bool mac_check = false;
  
//   String? _scanResult;
//   Future<void> checkmac() async {
//     await get_Mac_Wifi();
//     List<dynamic> mac = await NetworkRequest().get_MAC_WIFI();
//     mac.forEach((element) {
//       if (get_MAC_WIFI == element['address']) {
//         mac_check = true;
//         print(element);
//       }
//     });
//     print("Check MAc $mac_check");
//   }

//   String? id_per;
//   bool check = false;
//   AudioPlayer player = AudioPlayer();
//   NetworkRequest _networkrequest = new NetworkRequest();
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   int distance = 0;
//   int meter = 0;
//   String? rollcall_time;
//   int timecheck = 5;
//   int time_delay = 5;
//   String? Text_QR;
//   String? get_MAC_WIFI;
//   bool checkwifi = false;
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadSaved();
//     getcalculateDistance();
//     getTime_Rollcall();
//     checkmac();
//   }

//   get_Mac_Wifi() async {
//     ActiveWifiNetwork activeWifiNetwork =
//         await AndroidFlutterWifi.getActiveWifiInfo();
//     get_MAC_WIFI = activeWifiNetwork.bssid;
//     print("GET MAC WIFI : ${get_MAC_WIFI}");
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: distance <= meter &&
//               distance != 0 &&
//               (mac_check==true || checkwifi == true)
//           ? Container(height: h * 0.4, child: _buildQrView(context))
//           : distance > meter &&
//                   distance != 0 &&
//                   mac_check==true
//               ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Lottie.asset("assets/lottie/sad.json"),
//                     Text(
//                       "Bạn không ở phạm vi của công ty.",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                     )
//                   ],
//                 )
//               : mac_check==false &&
//                       distance > meter &&
//                       distance != 0
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Lottie.asset("assets/lottie/sad.json"),
//                         Text(
//                           "Bạn không ở phạm vi và Wifi không hợp lệ.",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 15),
//                         )
//                       ],
//                     )
//                   : mac_check==false &&
//                           distance < meter &&
//                           distance != 0
//                       ? Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Lottie.asset("assets/lottie/wifierror.json"),
//                             Text(
//                               "Wifi không hợp lệ bạn có muốn điểm danh lỗi ?",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 15),
//                             ),
//                             MaterialButton(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(7)),
//                                 color: Colors.blueAccent,
//                                 onPressed: () {
//                                   checkwifi = true;
//                                   setState(() {});
//                                 },
//                                 child: Text(
//                                   "Điểm danh",
//                                   style: TextStyle(color: Colors.blue),
//                                 ))
//                           ],
//                         )
//                       : Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Lottie.asset("assets/lottie/checkinglocation.json"),
//                             Text("Đang kiểm tra vị trí và Wifi của bạn.",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 18))
//                           ],
//                         ),
//     );
//   }

//   Widget _buildQrView(BuildContext context) {
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//             MediaQuery.of(context).size.height < 400)
//         ? 150.0
//         : 300.0;
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//           borderColor: Colors.red,
//           borderRadius: 10,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: scanArea),
//       onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) async {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) async {
//       setState(() {
//         result = scanData;
//         describeEnum(result!.format);
//       });
//       if (check == false) {
//              print( result?.code);
//         check = true;
//         if (timecheck >= time_delay &&
//             result?.code == Text_QR &&
//             mac_check==true) {
//           // showDialog(
//           //   context: context,
//           //   builder: (context) {
//           //     return AlertDialog(
//           //       content: Lottie.asset("assets/lottie/loadingrollcall.json"),
//           //     );
//           //   },
//           // );
       
//           if (await _networkrequest.rollcall_personnel(
//                   id_per,
//                   context
//                       .watch<Location_Provider>()
//                       .current_address()
//                       .toString()) ==
//               "Successful Attendance") {
//             //           Navigator.pop(context);
//             CherryToast.success(
//               title: Text("Điểm danh thành công"),
//               toastDuration: Duration(seconds: 2),
//             ).show(context);
//             playBeepSucces();
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             prefs.setString('rollcall_time', DateTime.now().toString());
//             await context
//                 .read<DetailRollCallUser_Provider>()
//                 .set_Data_Day_OneDay();
//           } else {
//             Navigator.pop(context);
//             CherryToast.error(title: Text("Bạn đã điểm danh hôm nay"))
//                 .show(context);
//             playBeepError();
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             prefs.setString('rollcall_time',
//                 DateTime.now().subtract(Duration(minutes: 5)).toString());
//           }
//         } else if (timecheck < time_delay &&
//             result?.code == Text_QR &&
//             mac_check==true) {
//           int res = time_delay - timecheck;
//           CherryToast.error(
//             title: Text(
//               "Bạn phải chờ $res phút để điểm danh",
//             ),
//             toastDuration: Duration(seconds: 2),
//           ).show(context);
//           playBeepError();
//         } else if (result?.code != Text_QR &&
//             mac_check==true) {
//           CherryToast.warning(
//             title: Text("Mã QR không hợp lệ !"),
//             toastDuration: Duration(seconds: 2),
//           ).show(context);
//           playBeepError();
//         }
//         await getTime_Rollcall();
//         DateTime current_time = DateTime.now();
//         if (rollcall_time != null) {
//           timecheck = current_time
//               .difference(DateTime.parse(rollcall_time.toString()))
//               .inMinutes;
//           print("timecheck : $timecheck");
//         }
//         await Future.delayed(Duration(seconds: 5));
//         check = false;
//       }
//     });
//   }

//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Chưa cấp quyền!')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   void playBeepSucces() async {
//     await player.play(AssetSource("sounds/tb.mp3"));
//   }

//   void playBeepError() async {
//     await player.play(AssetSource("sounds/error.mp3"));
//   }

//   Future<void> _loadSaved() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     id_per = prefs.getString('id_per');
//     rollcall_time = prefs.getString('rollcall_time');
//     if (id_per != null || rollcall_time != null) {
//       setState(() {});
//     }
//   }

//   Future<void> getcalculateDistance() async {
//     await _requestLocationPermission();
//     double _distance = await _calculateDistance();
//     Text_QR = await _networkrequest.get_Text_QR_Rollcall();
//     distance = _distance.round();
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Future<void> _requestLocationPermission() async {
//     var status = await Permission.location.request();
//     if (status.isDenied) {
//       CherryToast.warning(
//               title: Text(
//                   "Bạn phải cấp quyền thì mới kiểm tra được phạm vi của bạn"))
//           .show(context);
//     }
//   }

//   Future<double> _calculateDistance() async {
//     var data = await _networkrequest.getLocation();
//     // print(data);
//     meter = data['meter'];
//     double fixedLatitude = double.parse(data['latitude']); // kinh độ
//     double fixedLongitude = double.parse(data['longitude']); // vĩ độ
//     Position currentPosition = await Geolocator.getCurrentPosition();
//     double distance = await Geolocator.distanceBetween(
//       currentPosition.latitude,
//       currentPosition.longitude,
//       fixedLatitude,
//       fixedLongitude,
//     );
//     return distance;
//   }

//   Future<void> getTime_Rollcall() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     rollcall_time = prefs.getString("rollcall_time");
//   }


// }
