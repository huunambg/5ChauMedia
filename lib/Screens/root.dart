
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:personnel_5chaumedia/Services/notification.dart';
import '/Models/detailrollcall.dart';
import '/Models/notification.dart';
import '/Models/wifi.dart';
import '/Screens/account.dart';
import '/Screens/listnotification.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'manamentrollcall.dart';
import 'package:connectivity/connectivity.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class RootUser extends StatefulWidget {
  const RootUser({super.key});
  @override
  State<RootUser> createState() => _RootUserState();
}

class _RootUserState extends State<RootUser> {
  String? id_per;
  int _currentindex = 0;
  int check_exist_Notification_visted = 0;

  final Connectivity _connectivity = Connectivity();

  // Hàm bắt sự kiện thay đổi trạng thái kết nối mạng
  void _updateConnectionStatus(ConnectivityResult result) {
    if (result.toString() == "ConnectivityResult.wifi") {
      context.read<Wifi_Provider>().setname(null);
    } else if (result.toString() == "ConnectivityResult.mobile") {
      context.read<Wifi_Provider>().setname("Đang dùng mạng di động");
    } else if (result.toString() == "ConnectivityResult.none") {
      context.read<Wifi_Provider>().setname("Không có");
    }
  }

FirebaseMessaging messaging = FirebaseMessaging.instance; 

void permison()async{
        NotificationSettings settings = await messaging.requestPermission(sound: true
  );
}

  @override
 void initState(){
    super.initState();   
    NotificationService().initNotification();
   context.read<Wifi_Provider>().setname(null);
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.subscribeToTopic('Personnel');
    permison();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received a foreground message: ${message.notification?.body}');
           NotificationService().showNotification(title: message.notification?.title,body: message.notification?.body);
      context
          .read<Notification_Provider>()
          .set_count_notification_not_checked();
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked from background: ${message.notification?.body}');
    });
    load_save();


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Bắt sự kiện người dùng bấm nút back
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Thông báo'),
            content: Text('Bạn có chắc muốn thoát không?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng dialog
                  SystemNavigator.pop(); // Đóng màn hình hiện tại
                },
                child: Text('Có'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng dialog
                },
                child: Text('Không'),
              ),
            ],
          ),
        );

        // Chặn việc thoát khỏi màn hình ngay lúc này
        return false;
      },
      child: Scaffold(
        body: tabs[_currentindex],
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentindex,
            onTap: (value) {
              setState(() {
                _currentindex = value;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Ionicons.home_outline), label: "Trang chính"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_box_outlined), label: "Quản lý"),
              BottomNavigationBarItem(
                  icon: context
                              .watch<Notification_Provider>()
                              .check_exist_Notification_visted() ==
                          0
                      ? Icon(
                          Ionicons.notifications,
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Ionicons.notifications,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                alignment: Alignment.center,
                                width: 13,
                                height: 13,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Text(
                                  "${context.watch<Notification_Provider>().check_exist_Notification_visted()}",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                  label: "Thông báo"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Tài khoản"),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> load_save() async {
    context.read<Notification_Provider>().set_id_personnel();
    context.read<Notification_Provider>().set_count_notification_not_checked();
    context.read<DetailRollCallUser_Provider>().set_id_per();
  }
  final tabs = [
    HomePageUser(),
    ManamentRollCall_Screen(),
    Notification_Screen(),
    Account()
  ];
}
