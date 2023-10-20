import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personnel_5chaumedia/Screens/loginnew.dart';
import 'package:personnel_5chaumedia/Services/networks.dart';
import 'package:personnel_5chaumedia/Widgets/nextscreen.dart';

class Register_Screen extends StatefulWidget {
  final data;
  const Register_Screen({Key? key, required this.data}) : super(key: key);
  @override
  State<Register_Screen> createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _name_controller = TextEditingController();
  TextEditingController _phone_Controller = TextEditingController();
  TextEditingController _department_Controller = TextEditingController();

  bool _isObscure = true;

  bool _isValidEmail = true;

  final List<String> items = [];
  String? selectedValue;
  String? selectedValue_id;

  void _validateEmail(String input) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    setState(() {
      _isValidEmail = emailRegExp.hasMatch(input);
    });
  }

  void load_data() {
    List<dynamic> res = widget.data;

    res.forEach((element) {
      items.add("${element['name']}");
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load_data();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
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
                Container(
                  height: h * 0.25,
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
                Container(
                  height: h * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      name_textfield(size),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      _department_selected(w, size),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      phone_TextField(size),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      emailTextField(size),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      passwordTextField(size),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                    ],
                  ),
                ),

                //sign in button here
                Container(
                    height: h * 0.07,
                    child: signup_Button(size, () async {
                      if (selectedValue == null ||
                          _emailController.text == "" ||
                          _phone_Controller.text.length == 0 ||
                          _passwordController.text.length == 0 ||
                          _name_controller.text.length == 0|| _phone_Controller.text.length < 10 || _phone_Controller.text.length > 12) {
                        CherryToast.warning(
                                title: Text("Vui lòng kiểm tra dữ liệu"))
                            .show(context);
                      } else {
                        String message = await NetworkRequest()
                            .register_personnel(
                                _name_controller.text,
                                _phone_Controller.text,
                                _emailController.text,
                                _passwordController.text,
                                selectedValue_id);

                        if (message == "Success") {
                          CherryToast.success(
                                  title: Text(
                                      "Đang ký thành công vui lòng chờ quản lý duyệt"))
                              .show(context);
                           setState(() {
                               _passwordController.text="";
                           });
                        } else {
                          CherryToast.warning(title: Text("Đang kí thất bại tài khoản đã tồn tại"))
                              .show(context);
                        }
                      }
                    })),

                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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

  Widget _department_selected(double w, Size size) {
    return Container(
      width: double.infinity,
      height: size.height / 13,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Row(
            children: [
              Icon(
                Icons.list_alt_outlined,
                size: 16,
                color: Color.fromARGB(255, 117, 117, 117),
              ),
              SizedBox(
                width: 7,
              ),
              Expanded(
                child: Text(
                  'Chọn phòng ban',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: items
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (String? value) {
            setState(() {
              List<dynamic> res = widget.data;
              res.forEach((element) {
                if (value == element['name']) {
                  selectedValue_id = element['id'];
                }
              });
              selectedValue = value;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: 160,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: selectedValue == null
                  ? null
                  : Border.all(color: Color(0xFF21899C)),
              color: const Color.fromRGBO(248, 247, 251, 1),
            ),
            elevation: 2,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: 14,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color.fromRGBO(248, 247, 251, 1),
            ),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(20),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }

  Widget phone_TextField(Size size) {
    return SizedBox(
        height: size.height / 13,
        child: TextField(
            controller: _phone_Controller,
            style: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624),
            ),
            maxLines: 1,
            keyboardType: TextInputType.number,
            cursorColor: const Color(0xFF21899C),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.phone,
                color: _phone_Controller.text.isEmpty
                    ? const Color(0xFF151624).withOpacity(0.5)
                    : const Color.fromRGBO(44, 185, 176, 1),
                size: 16,
              ),
              //     errorText: _isValidEmail ? null : 'Enter a valid email',
              hintText: 'Nhập số điện thoại',
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
                      color: _phone_Controller.text.isEmpty
                          ? Colors.transparent
                          : const Color(0xFF21899C))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: _phone_Controller.text.isEmpty
                          ? Colors.transparent
                          : const Color(0xFF21899C))),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                _phone_Controller.text;
              });
            }));
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

  Widget name_textfield(Size size) {
    return SizedBox(
        height: size.height / 13,
        child: TextField(
          controller: _name_controller,
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFF151624),
          ),
          maxLines: 1,
          cursorColor: const Color(0xFF21899C),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: _name_controller.text.isEmpty
                  ? const Color(0xFF151624).withOpacity(0.5)
                  : const Color.fromRGBO(44, 185, 176, 1),
              size: 16,
            ),
            //     errorText: _isValidEmail ? null : 'Enter a valid email',
            hintText: 'Nhập tên',
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
                    color: _name_controller.text.isEmpty
                        ? Colors.transparent
                        : const Color(0xFF21899C))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: _name_controller.text.isEmpty
                        ? Colors.transparent
                        : const Color(0xFF21899C))),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _name_controller.text;
            });
          },
        ));
  }

  Widget signup_Button(Size size, GestureTapCallback ontap) {
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
          'Đăng ký',
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

  Widget buildFooter(Size size) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.01,
          ),
          //footer text here
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bạn đã có tài khoản?',
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
                  Next_Screeen().pushReplacement(context, Login_Screen_new());
                },
                child: Text(
                  "Đăng nhập",
                  style: TextStyle(
                    color: Color(0xFFFF7248),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              //  )
            ],
          )
        ],
      ),
    );
  }
}
