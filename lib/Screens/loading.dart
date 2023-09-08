import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:personnel_5chaumedia/Screens/admin/homeadmin.dart';
import 'package:personnel_5chaumedia/Screens/loginnew.dart';
import '/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'root.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = await prefs.getString('email');
    String? savedPassword = await prefs.getString('password');
    bool? is_Logout = await prefs.getBool("is_logout");

    if (savedEmail != null && savedPassword != null && is_Logout == false) {
      String url = '$URL_LOGIN';

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> data = {
        'email': savedEmail,
        'password': savedPassword,
      };

      try {
        var response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(data),
        );
        if (response.statusCode == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
           print(jsonDecode(response.body));
        var data = jsonDecode(response.body)['user'];
        if (data['role'] == 'personnel') {
          var data2 = jsonDecode(response.body)['id_per'][0];
          var data3 = jsonDecode(response.body)['pid'];
          String id_per = data2['id'].toString();
          String user_name = data['name'].toString();
          String email = data['email'];
          String id_personnel = data3[0]['id'];
          String phone =
              jsonDecode(response.body)['phone'][0]['phone'].toString();
          String id_company = data['company_id'];
          String company_name = jsonDecode(response.body)['company'];
          String department_name = jsonDecode(response.body)['department'];
          // print(
          //     "Phone $phone id_personnel: $id_personnel email $email ,user_name :$user_name ,id_per: $id_per  ,company_id :$id_company");
          await prefs.setString('id_per', id_per);
          await prefs.setString('user_name', user_name);
          await prefs.setString('email', email);
          await prefs.setString('id_personnel', id_personnel);
          await prefs.setString('phone', phone);
          await prefs.setString('company_id', id_company);
          await prefs.setString('company_name', company_name);
          await prefs.setString('department', department_name);
          // Chuyển đến màn hình chính hoặc màn hình tiếp theo
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RootUser(
                      id_company: '$id_company',
                    )),
          );
        } else {
          String id_company = data['company_id'];
            await prefs.setString('company_id', id_company);
                    Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeAdmin()),
          );
        }
        } else {
          // Đăng nhập thất bại
          var responseData = jsonDecode(response.body);
          String errorMessage = responseData['message'];

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Đăng nhập thất bại !'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login_Screen_new()),
                    );
                  },
                ),
              ],
            ),
          );
        }
      } catch (error) {
        // Xảy ra lỗi kết nối
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Lỗi'),
            content: Text('Đã xảy ra lỗi kết nối.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login_Screen_new()),
                  );
                },
              ),
            ],
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login_Screen_new()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
