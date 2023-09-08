import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personnel_5chaumedia/Screens/admin/homeadmin.dart';
import 'package:personnel_5chaumedia/Screens/root.dart';
import 'package:personnel_5chaumedia/Services/networks.dart';
import 'package:personnel_5chaumedia/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_Screen_new extends StatefulWidget {
  const Login_Screen_new({Key? key}) : super(key: key);
  @override
  State<Login_Screen_new> createState() => _Login_Screen_newState();
}

class _Login_Screen_newState extends State<Login_Screen_new> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _rememberMe = false;
  NetworkRequest x = new NetworkRequest();
  AudioPlayer player = AudioPlayer();
  bool _isValidEmail = true;
  void _validateEmail(String input) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    setState(() {
      _isValidEmail = emailRegExp.hasMatch(input);
    });
  }

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
        builder: (context) => AlertDialog(
          content: Container(
            height: h * 0.3,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Đăng nhập thành công
        if (_rememberMe) {
          await prefs.setString('email', _emailController.text);
          await prefs.setString('password', _passwordController.text);
          await prefs.setBool('rememberMe', true);
          await prefs.setBool("is_logout", false);
        } else {
          await prefs.remove('email');
          await prefs.remove('password');
          await prefs.remove('rememberMe');
        }

        var data = jsonDecode(response.body)['user'];

        print(jsonDecode(response.body));

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
        Navigator.pop(context);
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
              gradient: RadialGradient(colors: [
            Color.fromRGBO(119, 210, 226, 0.149),
            Colors.white,
          ], center: Alignment.topRight, radius: 0.8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      logo(size.height / 8, size.height / 8),
                    ],
                  ),
                ),

                //email, password textField and recovery password here
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      emailTextField(size),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      passwordTextField(size),
                      buildRemember_Password(size)
                    ],
                  ),
                ),

                //sign in button here
                Expanded(
                    flex: 1,
                    child: signInButton(
                      size,
                      () => _login(MediaQuery.of(context).size.height),
                    )),

                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildNoAccountText(),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      buildFooter(size),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logo(double height_, double width_) {
    return Image.asset(
      'assets/images/logo_5chaumedia_login.png',
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: const Color(0xFF21899C),
          letterSpacing: 2.000000061035156,
        ),
        children: const [
          TextSpan(
            text: '5 Châu',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: ' Media',
            style: TextStyle(
              color: Color(0xFFFE9879),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget emailTextField(Size size) {
    return SizedBox(
      height: size.height / 13,
      child: TextField(
        controller: _emailController,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF151624),
        ),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        cursorColor: const Color(0xFF21899C),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.mail_outline_rounded,
            color: _emailController.text.isEmpty
                ? const Color(0xFF151624).withOpacity(0.5)
                : const Color.fromRGBO(44, 185, 176, 1),
            size: 16,
          ),
          //     errorText: _isValidEmail ? null : 'Enter a valid email',
          hintText: 'Nhập email',
          hintStyle: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFFABB3BB),
            height: 1.0,
          ),
          filled: true,
          fillColor: const Color.fromRGBO(248, 247, 251, 1),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: _emailController.text.isEmpty
                      ? Colors.transparent
                      : const Color(0xFF21899C))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: _emailController.text.isEmpty
                      ? Colors.transparent
                      : const Color(0xFF21899C))),
          border: InputBorder.none,
          suffix: _isValidEmail != true
              ? null
              : Container(
                  alignment: Alignment.center,
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: Color.fromRGBO(44, 185, 176, 1),
                  ),
                  child: _emailController.text.isEmpty
                      ? null
                      : Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 13,
                        ),
                ),
        ),
        onChanged: _validateEmail,
      ),
    );
  }

  Widget passwordTextField(Size size) {
    return SizedBox(
      height: size.height / 13,
      child: TextField(
        obscureText: _isObscure,
        controller: _passwordController,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF151624),
        ),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        cursorColor: const Color(0xFF21899C),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            color: _passwordController.text.isEmpty
                ? const Color(0xFF151624).withOpacity(0.5)
                : const Color.fromRGBO(44, 185, 176, 1),
            size: 16,
          ),
          hintText: 'Nhập mật khẩu',
          hintStyle: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFFABB3BB),
            height: 1.0,
          ),
          filled: true,
          fillColor: const Color.fromRGBO(248, 247, 251, 1),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: _passwordController.text.isEmpty
                      ? Colors.transparent
                      : const Color(0xFF21899C))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: _passwordController.text.isEmpty
                      ? Colors.transparent
                      : const Color(0xFF21899C))),
          border: InputBorder.none,
          suffix: _passwordController.text.isEmpty
              ? null
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  child: Container(
                    height: 30,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(249, 225, 224, 1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Color.fromRGBO(254, 152, 121, 1),
                        )),
                    child: _isObscure != false
                        ? Text(
                            'Hiện',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: const Color(0xFFFE9879),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Text(
                            'Ẩn',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: Color.fromARGB(255, 78, 173, 228),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
        ),
        onChanged: (value) {
          setState(() {
            _passwordController.text;
          });
        },
      ),
    );
  }

  Widget buildRemember_Password(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _rememberMe = !_rememberMe;
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color(0xFF21899C),
              ),
              child: _rememberMe == true
                  ? Icon(
                      Icons.check,
                      size: 13,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            'Lưu mật khấu',
            style: GoogleFonts.inter(
              fontSize: 15.0,
              color: const Color(0xFF0C0D34),
            ),
          ),
          const Spacer(),
          TextButton(
              onPressed: () {
                CherryToast.warning(title: Text("Đang update!")).show(context);
                playBeepWarning();
              },
              child: Text(
                'Quên mật khẩu?',
                style: GoogleFonts.inter(
                  fontSize: 13.0,
                  color: const Color(0xFF21899C),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              )),
        ],
      ),
    );
  }

  Widget signInButton(Size size, GestureTapCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        height: size.height / 13,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.blueAccent,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4C2E84).withOpacity(0.2),
              offset: const Offset(0, 15.0),
              blurRadius: 60.0,
            ),
          ],
        ),
        child: Text(
          'Đăng Nhập',
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildNoAccountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Expanded(
            flex: 2,
            child: Divider(
              color: Color.fromARGB(0, 242, 242, 243),
            )),
        Expanded(
          flex: 3,
          child: Text(
            '',
          ),
        ),
        const Expanded(
            flex: 2,
            child: Divider(
              color: Color.fromARGB(0, 242, 242, 243),
            )),
      ],
    );
  }

  Widget buildFooter(Size size) {
    return Center(
      child: Column(
        children: <Widget>[
          //social icon here
          SizedBox(
            height: 44.0,
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          //footer text here
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bạn chưa có tài khoản?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFF969AA8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  CherryToast.warning(title: Text("Đang update!"))
                      .show(context);
                  playBeepWarning();
                },
                child: Text(
                  "Đang kí tài khoản",
                  style: TextStyle(
                    color: Color(0xFFFF7248),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          )
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

  void playBeepWarning() async {
    await player.play(AssetSource("sounds/warning.mp3"));
  }
}
