import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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
          var data = jsonDecode(response.body)['user'];
          var data2 = jsonDecode(response.body)['id_per'][0];
          await prefs.setString('id_per', data2['id'].toString());
          await prefs.setString('user_name', data['name'].toString());
          await prefs.setBool("is_logout", false);
          var data3 = jsonDecode(response.body)['pid'];
          await prefs.setString('id_personnel', data3[0]['personnel_id']);
          await prefs.setString('email',data['email']);
          
        //  print(jsonDecode(response.body));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RootUser()),
          );
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
