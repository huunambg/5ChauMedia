import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
        var data2 = jsonDecode(response.body)['id_per'][0];
        await prefs.setString('id_per', data2['id'].toString());
        await prefs.setString('user_name', data['name'].toString());
        await prefs.setString('email', data['email']);
        //  print(jsonDecode(response.body));
        var data3 = jsonDecode(response.body)['pid'];
        await prefs.setString('id_personnel', data3[0]['personnel_id']);
        await prefs.setString(
            'phone', jsonDecode(response.body)['phone'][0]['phone']);
        // Chuyển đến màn hình chính hoặc màn hình tiếp theo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RootUser()),
        );
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
      Navigator.pop(context);
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
            Color.fromRGBO(33, 137, 156, 0.15),
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
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      richText(20.42),
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
    return SvgPicture.asset(
      'assets/icons/logo2.svg',
      height: height_,
      width: width_,
      color: Colors.deepPurpleAccent,
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
          suffix: _isValidEmail !=true
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
        onChanged:_validateEmail,
        
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
                            'Xem',
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
              color: Color(0xFF969AA8),
            )),
        Expanded(
          flex: 3,
          child: Text(
            'Bạn chưa có tài khoản?',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF969AA8),
              fontWeight: FontWeight.w500,
              height: 1.67,
            ),
          ),
        ),
        const Expanded(
            flex: 2,
            child: Divider(
              color: Color(0xFF969AA8),
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
            width: size.width * 0.6,
            height: 44.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //facebook logo here
                GestureDetector(
                  onTap: () {
                    CherryToast.warning(title: Text("Đang update!"))
                        .show(context);
                    playBeepWarning();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: const Color.fromRGBO(246, 246, 246, 1)),
                    child: SvgPicture.string(
                      '<svg viewBox="0.3 0.27 22.44 22.44" ><defs><linearGradient id="gradient" x1="0.500031" y1="0.970054" x2="0.500031" y2="0.0"><stop offset="0.0" stop-color="#ff0062e0"  /><stop offset="1.0" stop-color="#ff19afff"  /></linearGradient></defs><path transform="translate(0.3, 0.27)" d="M 9.369577407836914 22.32988739013672 C 4.039577960968018 21.3760986328125 0 16.77546882629395 0 11.22104930877686 C 0 5.049472332000732 5.049472808837891 0 11.22105026245117 0 C 17.39262962341309 0 22.44210624694824 5.049472332000732 22.44210624694824 11.22104930877686 C 22.44210624694824 16.77546882629395 18.40252304077148 21.3760986328125 13.07252502441406 22.32988739013672 L 12.45536518096924 21.8249397277832 L 9.986735343933105 21.8249397277832 L 9.369577407836914 22.32988739013672 Z" fill="url(#gradient)" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(6.93, 4.65)" d="M 8.976840972900391 9.986734390258789 L 9.481786727905273 6.844839572906494 L 6.508208274841309 6.844839572906494 L 6.508208274841309 4.656734466552734 C 6.508208274841309 3.759051322937012 6.844841003417969 3.085787773132324 8.191367149353027 3.085787773132324 L 9.650103569030762 3.085787773132324 L 9.650103569030762 0.2244201600551605 C 8.864629745483398 0.1122027561068535 7.966946125030518 0 7.181471347808838 0 C 4.600629806518555 0 2.805262804031372 1.570946097373962 2.805262804031372 4.376209735870361 L 2.805262804031372 6.844839572906494 L 0 6.844839572906494 L 0 9.986734390258789 L 2.805262804031372 9.986734390258789 L 2.805262804031372 17.8975715637207 C 3.422420024871826 18.00978851318359 4.039577484130859 18.06587600708008 4.656735897064209 18.06587600708008 C 5.273893356323242 18.06587600708008 5.89105224609375 18.009765625 6.508208274841309 17.8975715637207 L 6.508208274841309 9.986734390258789 L 8.976840972900391 9.986734390258789 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                      width: 22.44,
                      height: 22.44,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                //google logo here
                GestureDetector(
                  onTap: () {
                    CherryToast.warning(title: Text("Đang update!"))
                        .show(context);
                    playBeepWarning();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: const Color.fromRGBO(246, 246, 246, 1)),
                    child: SvgPicture.string(
                      // Group 59
                      '<svg viewBox="11.0 11.0 22.92 22.92" ><path transform="translate(11.0, 11.0)" d="M 22.6936149597168 9.214142799377441 L 21.77065277099609 9.214142799377441 L 21.77065277099609 9.166590690612793 L 11.45823860168457 9.166590690612793 L 11.45823860168457 13.74988651275635 L 17.93386268615723 13.74988651275635 C 16.98913192749023 16.41793632507324 14.45055770874023 18.33318138122559 11.45823860168457 18.33318138122559 C 7.661551475524902 18.33318138122559 4.583295345306396 15.25492572784424 4.583295345306396 11.45823860168457 C 4.583295345306396 7.661551475524902 7.661551475524902 4.583295345306396 11.45823860168457 4.583295345306396 C 13.21077632904053 4.583295345306396 14.80519008636475 5.244435787200928 16.01918983459473 6.324374675750732 L 19.26015281677246 3.083411931991577 C 17.21371269226074 1.176188230514526 14.47633838653564 0 11.45823860168457 0 C 5.130426406860352 0 0 5.130426406860352 0 11.45823860168457 C 0 17.78605079650879 5.130426406860352 22.91647720336914 11.45823860168457 22.91647720336914 C 17.78605079650879 22.91647720336914 22.91647720336914 17.78605079650879 22.91647720336914 11.45823860168457 C 22.91647720336914 10.68996334075928 22.83741569519043 9.940022468566895 22.6936149597168 9.214142799377441 Z" fill="#ffc107" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(12.32, 11.0)" d="M 0 6.125000953674316 L 3.764603137969971 8.885863304138184 C 4.78324031829834 6.363905429840088 7.250198841094971 4.583294868469238 10.13710117340088 4.583294868469238 C 11.88963890075684 4.583294868469238 13.48405265808105 5.244434833526611 14.69805240631104 6.324373722076416 L 17.93901443481445 3.083411693572998 C 15.89257335662842 1.176188111305237 13.15520095825195 0 10.13710117340088 0 C 5.735992908477783 0 1.919254422187805 2.484718799591064 0 6.125000953674316 Z" fill="#ff3d00" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(12.26, 24.78)" d="M 10.20069408416748 9.135653495788574 C 13.16035556793213 9.135653495788574 15.8496036529541 8.003005981445312 17.88286781311035 6.161093711853027 L 14.33654403686523 3.160181760787964 C 13.14749050140381 4.064460277557373 11.69453620910645 4.553541660308838 10.20069408416748 4.55235767364502 C 7.220407009124756 4.55235767364502 4.689855575561523 2.6520094871521 3.736530303955078 0 L 0 2.878881216049194 C 1.896337866783142 6.589632034301758 5.747450828552246 9.135653495788574 10.20069408416748 9.135653495788574 Z" fill="#4caf50" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(22.46, 20.17)" d="M 11.23537635803223 0.04755179211497307 L 10.31241607666016 0.04755179211497307 L 10.31241607666016 0 L 0 0 L 0 4.583295345306396 L 6.475625038146973 4.583295345306396 C 6.023715496063232 5.853105068206787 5.209692478179932 6.962699413299561 4.134132385253906 7.774986743927002 L 4.135851383209229 7.773841857910156 L 7.682177066802979 10.77475357055664 C 7.431241512298584 11.00277233123779 11.45823955535889 8.020766258239746 11.45823955535889 2.291647672653198 C 11.45823955535889 1.523372769355774 11.37917804718018 0.773431122303009 11.23537635803223 0.04755179211497307 Z" fill="#1976d2" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                      width: 22.92,
                      height: 22.92,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          //footer text here
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bạn chưa có tài khoản",
                style: TextStyle(
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
