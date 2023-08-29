//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
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
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          await NetworkRequest().fetchData_Notification();
         setState(() {
           
         });
    });
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
        double w = MediaQuery.of(context).size.width;
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
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.all(10),
                        height: h * 0.17,
                        decoration: BoxDecoration(
                       border: Border(bottom: BorderSide(color: Color.fromARGB(255, 172, 163, 163))),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 2,
                          //     blurRadius: 5,
                          //     offset: Offset(0,
                          //         1), // Điều chỉnh vị trí của bóng theo trục x và y
                          //   ),
                          // ],
                          color: check(snapshot.data?[index]['id']) == false
                              ? Color.fromARGB(120, 206, 198, 198)
                              : Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                Container(
                                  width: w*0.7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TruncateText_Bold( "📢 ${snapshot.data?[index]['title']}", maxLength: 60, size: 15),
                                      SizedBox(height: 7,),
                                          TruncateText(
                                                "${snapshot.data?[index]['content']}.",
                                                maxLength: 100),
                                    ],
                                  ),
                                ),
                                    
                                  ],
                                ),
         
                            Text(
                                "${DateFormat("H:m:s dd/MM/yy").format(DateTime.parse(snapshot.data?[index]['created_at']).add(Duration(hours: 7)))}",style: TextStyle(fontSize: 10),),
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
