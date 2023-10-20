import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personnel_5chaumedia/Screens/loginnew.dart';
import 'package:personnel_5chaumedia/Screens/register.dart';
import 'package:personnel_5chaumedia/Services/networks.dart';
import 'package:personnel_5chaumedia/Widgets/nextscreen.dart';
import 'package:personnel_5chaumedia/Widgets/sound.dart';

class Check_ID_Company_Register extends StatefulWidget {
  const Check_ID_Company_Register({Key? key}) : super(key: key);
  @override
  State<Check_ID_Company_Register> createState() =>
      _Check_ID_Company_RegisterState();
}

class _Check_ID_Company_RegisterState extends State<Check_ID_Company_Register> {
  TextEditingController _companyController = TextEditingController();

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
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      emailTextField(size),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                    ],
                  ),
                ),

                //sign in button here
                Expanded(
                    flex: 1,
                    child: company_button(size, () async {
                      if (_companyController.text != "") {
                        var data = await NetworkRequest()
                            .check_company_id(_companyController.text);
                        if (data != "Error") {
                          Next_Screeen()
                              .pushReplacement(context, Register_Screen(data: data,));
                        }
                        else{
                           CherryToast.warning(
                                title: Text("Mã công ty không tồn tại"))
                            .show(context);
                        }

                      } else {
                        Sound().playBeepWarning();
                        CherryToast.warning(
                                title: Text("Vui lòng kiểm tra dữ liệu"))
                            .show(context);
                      }
                    })),

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
            controller: _companyController,
            style: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624),
            ),
            maxLines: 1,
            cursorColor: const Color(0xFF21899C),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.info_outline_rounded,
                color: _companyController.text.isEmpty
                    ? const Color(0xFF151624).withOpacity(0.5)
                    : const Color.fromRGBO(44, 185, 176, 1),
                size: 16,
              ),
              hintText: 'Nhập mã công ty',
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
                      color: _companyController.text.isEmpty
                          ? Colors.transparent
                          : const Color(0xFF21899C))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: _companyController.text.isEmpty
                          ? Colors.transparent
                          : const Color(0xFF21899C))),
              border: InputBorder.none,
            )));
  }

  Widget company_button(Size size, GestureTapCallback ontap) {
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
          'Đăng Ký',
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
