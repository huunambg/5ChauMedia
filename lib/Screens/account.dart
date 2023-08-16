import 'package:audioplayers/audioplayers.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '/Models/settings.dart';
import '/Widgets/itemaccount.dart';
import '/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  AudioPlayer player = AudioPlayer();
  String? user_name;
  String? id_per;
  bool check_color = false;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  int check_exist_Notification_visted = 0;

  @override
  Widget build(BuildContext context) {
    // double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Color(context.watch<Setting_Provider>().background_color()),
        body: ListView(
          padding: EdgeInsets.only(top: 35, bottom: 10, left: 10, right: 10),
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  child: LottieBuilder.asset("assets/lottie/girl.json"),
                ),
                SizedBox(height: 10),
                Text(
                  "$user_name",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Nhân viên chính thức")
              ],
            ),
            SizedBox(height: 20),
            ItemAccount_OK(
                icon: Icons.attach_money,
                onpressed: () {
                  CherryToast.warning(title: Text("Đang update!"))
                      .show(context);
                  playBeepWarning();
                },
                titile: "Lương"),
            ItemAccount_OK(
                icon: Icons.lock,
                onpressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Đổi mật khẩu"),
                        content: TextField(
                            decoration: InputDecoration(
                                labelText: "Nhập mật khẩu mới")),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Quay lại"),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Xác nhận"))
                        ],
                      );
                    },
                  );
                },
                titile: "Đổi mật khẩu"),
            ItemAccount_OK(
                icon: Ionicons.help,
                onpressed: () async {
                  NetworkInfo networkInfo = NetworkInfo();
                  String? Mac = await networkInfo.getWifiBSSID();
                  CherryToast.info(title: Text("${Mac}")).show(context);
                },
                titile: "Show MAC WIFI"),
            ItemAccount_OK(
                icon: Ionicons.settings,
                onpressed: () {
                  check_color = !check_color;
                  context
                      .read<Setting_Provider>()
                      .set_background_color(check_color);
                },
                titile: "Cài đặt"),
            ItemAccount_OK(
                icon: Ionicons.arrow_back_circle_outline,
                onpressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Thông báo'),
                      content: Text('Bạn có chắc muốn đăng xuất không?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            logout(context);
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
                },
                titile: "Đăng xuất"),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id_per = prefs.getString('id_per');
    user_name = prefs.getString('user_name');

    if (id_per != null || user_name != null) {
      setState(() {});
    }
  }

  Future<void> logout(BuildContext context) async {
    final respone = await http.get(Uri.parse(URL_LOGOUT));
    if (respone.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("is_logout", true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  void playBeep() async {
    await player.play(AssetSource("sounds/tb.mp3"));
  }

  void playBeepWarning() async {
    await player.play(AssetSource("sounds/warning.mp3"));
  }
}
