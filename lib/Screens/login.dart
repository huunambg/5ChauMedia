import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/Services/networks.dart';
import '/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'root.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  NetworkRequest x = new NetworkRequest();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _login(double h) async {
    String url = '$URL_LOGIN';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> data = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };
    try {
      showDialog(
        context: context,
        builder: (context) => 
         AlertDialog(
            content: Container(height: h*0.4,child: Center(child: CircularProgressIndicator(),),),
          ),
      );
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );
      Navigator.pop(context);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Đăng nhập thành công
        if (_rememberMe) {
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', _emailController.text);
          await prefs.setString('password', _passwordController.text);
          await prefs.setBool('rememberMe', true);
          await prefs.setBool("is_logout", false);
        } else {
          //      SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('email');
          await prefs.remove('password');
          await prefs.remove('rememberMe');
        }
        var data = jsonDecode(response.body)['user'];
        var data2 = jsonDecode(response.body)['id_per'][0];
        await prefs.setString('id_per', data2['id'].toString());
        await prefs.setString('user_name', data['name'].toString());
        var data3 = jsonDecode(response.body)['pid'];
        await prefs.setString('id_personnel', data3[0]['personnel_id']);
        // Chuyển đến màn hình chính hoặc màn hình tiếp theo
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
            title: Text('Đăng nhập thất bại!'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7F67BE),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset('assets/team.png', width: 110, height: 110),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('5 Châu Media',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                  const Text('Đăng nhập để tiếp tục',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: ' Email',
                          ),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Email';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            Text('Lưu mật khẩu'),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: btlogin_color,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            onPressed: () {
                              _login(MediaQuery.of(context).size.height);
                            },
                            child: const Text(
                              'Đăng nhập',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Bạn chưa có tài khoản!'),
                            TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                onPressed: () {
                                  CherryToast.warning(
                                          title: Text(
                                              "Vui lòng liên hệ quản trị để đang kí"))
                                      .show(context);
                                },
                                child: const Text('Đăng kí ngay')),
                          ],
                        )
                      ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');
    bool? savedRememberMe = prefs.getBool('rememberMe');
    String? name = prefs.getString('user_name');
    print(name);

    if (savedEmail != null &&
        savedPassword != null &&
        savedRememberMe != null &&
        savedRememberMe) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }
}
