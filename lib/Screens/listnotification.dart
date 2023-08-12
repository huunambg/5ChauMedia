//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '/Models/notification.dart';
import '/Models/settings.dart';
import '/Services/networks.dart';
import '/Widgets/TruncateText.dart';
import '/Widgets/appbar.dart';
import '/Widgets/showmodelbottomsheet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notification_Screen extends StatefulWidget {
  const Notification_Screen({super.key});

  @override
  State<Notification_Screen> createState() => _Notification_ScreenState();
}

class _Notification_ScreenState extends State<Notification_Screen> {
  String? id_per;
  NetworkRequest _networkRequest = new NetworkRequest();
  List<dynamic> data_checked = [];
  Future<void> load_save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id_per = prefs.getString('id_personnel');
  }

  Future<void> fetch_data() async {
    await load_save();
    data_checked =
        await _networkRequest.fetch_Data_Notification_Checked(id_per);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetch_data();
  }

  bool check(int id) {
    bool res = false;
    data_checked.forEach((item) {
      if (item == id) {
        res = true;
      }
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          backgroundColor:
              Color(context.watch<Setting_Provider>().background_color()),
          appBar: CustomAppBar(context),
          body: FutureBuilder(
            future: NetworkRequest().fetchData_Notification(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: EdgeInsets.all(7),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        _networkRequest.set_Data_Notification_Checked(
                            id_per, snapshot.data?[index]['id']);
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return CusstomshowModalBottomSheet(
                              images: "assets/team.png",
                              title: snapshot.data?[index]['title'],
                              content: snapshot.data?[index]['content'],
                              time: DateFormat("H:m:s dd/MM/yy").format(DateTime.parse(snapshot.data?[index]['created_at']).add(Duration(hours: 7))),
                            );
                          },
                        );
                        context
                            .read<Notification_Provider>()
                            .set_count_notification_not_checked();
                        await fetch_data();
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.all(10),
                        height: h * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0,
                                  1), // Điều chỉnh vị trí của bóng theo trục x và y
                            ),
                          ],
                          color: check(snapshot.data?[index]['id']) == false
                              ? Color.fromARGB(120, 160, 129, 129)
                              : Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Ionicons.notifications_circle,
                                  size: 35,
                                ),
                                SizedBox(width: 5,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${snapshot.data?[index]['title']}",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    TruncateText(
                                        "${snapshot.data?[index]['content']}.",
                                        maxLength: 25)
                                  ],
                                ),
                              ],
                            ),
                            Text(
                                "${DateFormat("H:m:s dd/MM/yy").format(DateTime.parse(snapshot.data?[index]['created_at']).add(Duration(hours: 7)))}"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
    );
  }

  String date_Format(DateTime dateTime) {
    String formattedDateTime = DateFormat("H:m:s dd/MM/YY").format(dateTime);
    return formattedDateTime;
  }
}
