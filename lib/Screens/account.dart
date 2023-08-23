import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:personnel_5chaumedia/Models/datauser.dart';
import 'package:personnel_5chaumedia/Screens/editpassword.dart';
import 'package:personnel_5chaumedia/Screens/editprofile.dart';
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
  String? id_per;
  bool check_color = false;
  int check_exist_Notification_visted = 0;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  @override
  Widget build(BuildContext context) {
    // double w = MediaQuery.of(context).size.width;
     double h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Color(context.watch<Setting_Provider>().background_color()),
        body: ListView(
          padding: EdgeInsets.only(top: 35, bottom: 10, left: 10, right: 10),
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Container(height: h*0.2,width: h*0.2,
                  child: context.read<DataUser_Provider>().base64_img() !="Error" && context.read<DataUser_Provider>().base64_img()!= "" ? Image(image: MemoryImage(base64Decode(context.watch<DataUser_Provider>().base64_img())),fit: BoxFit.cover,): Lottie.asset("assets/lottie/girl.json",fit: BoxFit.cover),
                  ),

                ),
                SizedBox(height: 10),
                Text(
                  "${context.watch<DataUser_Provider>().name_personnel()}",
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
                icon: Icons.person_outline_outlined,
                onpressed: () {
                  context.read<DataUser_Provider>().set_base64_img_edit(context.read<DataUser_Provider>().base64_img());
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Edit_Profile_Screen()));
                },
                titile: "Chỉnh sửa thông tin"),
            ItemAccount_OK(
                icon: Icons.lock,
                onpressed: () {
                 
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Edit_Password_Screen()));
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
