import 'package:flutter/material.dart';
import 'package:personnel_5chaumedia/Models/datauser.dart';
import 'package:personnel_5chaumedia/Screens/admin/location.dart';
import 'package:personnel_5chaumedia/Screens/admin/mac.dart';
import 'package:personnel_5chaumedia/Screens/loginnew.dart';
import 'package:personnel_5chaumedia/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}



class _HomeAdminState extends State<HomeAdmin> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  void load(){
    context.read<DataUser_Provider>().set_id_company();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 239, 239),
        appBar: AppBar(
            backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          title: Text(
            "Quản trị",
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: GridView(
          padding: EdgeInsets.all(15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 160,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          children: [
            CustomItemHome(
              image: "assets/location.png",
              text: "Thiết lập vị trí",
              onpressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Set_Location()));
              },
            ),
            CustomItemHome(
              image: "assets/wifi.png",
              text: "Thiết lập Wifi",
              onpressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Set_Mac_Wifi()),
                );
              },
            ),
              CustomItemHome(
              image: "assets/logout.png",
              text: "Đăng xuất",
              onpressed: () {
              logout(context);
              },
            )
            
          ],
        ));
  }

    Future<void> logout(BuildContext context) async {
    final respone = await http.get(Uri.parse(URL_LOGOUT));
    if (respone.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("is_logout", true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login_Screen_new()));
    }
  }
}

class CustomItemHome extends StatelessWidget {
  const CustomItemHome(
      {super.key,
      required this.image,
      required this.text,
      required this.onpressed});
  final String image;
  final String text;
  final GestureTapCallback onpressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        elevation: 2,
        color: Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: onpressed,
        child: Container(
          padding: EdgeInsets.only(top: 30,bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: Image.asset("$image"),
              ),
              Text('$text',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)))
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Color.fromARGB(255, 219, 218, 218)]),
          borderRadius: BorderRadius.circular(20)),
    );
  }
}
