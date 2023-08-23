import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:personnel_5chaumedia/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Edit_Password_Screen extends StatefulWidget {
  const Edit_Password_Screen({super.key});

  @override
  State<Edit_Password_Screen> createState() => _Edit_Password_ScreenState();
}

// hihi

class _Edit_Password_ScreenState extends State<Edit_Password_Screen> {
  bool check_old_pass = true;
  bool check_new_pass = true;
  bool check_renew_pass = true;
  final old_pass_controller = TextEditingController();
  final new_pass_controller = TextEditingController();
  final renew_pass_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7F67BE),
        title: Text("Đổi mật khẩu"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
                controller: old_pass_controller,
                obscureText: check_old_pass,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            check_old_pass = !check_old_pass;
                          });
                        },
                        icon: Icon(check_old_pass
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    labelText: "Nhập mật khẩu cũ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)))),
            SizedBox(
              height: 10,
            ),
            TextField(
                obscureText: check_new_pass,
                controller: new_pass_controller,
                decoration: InputDecoration(
                  labelText: "Nhập mật khẩu mới",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          check_new_pass = !check_new_pass;
                        });
                      },
                      icon: Icon(check_new_pass
                          ? Icons.visibility
                          : Icons.visibility_off)),
                )),
            SizedBox(
              height: 10,
            ),
            TextField(
                obscureText: check_renew_pass,
                controller: renew_pass_controller,
                decoration: InputDecoration(
                  labelText: "Nhập lại mật khẩu mới",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          check_renew_pass = !check_renew_pass;
                        });
                      },
                      icon: Icon(check_renew_pass
                          ? Icons.visibility
                          : Icons.visibility_off)),
                )),
            SizedBox(
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
                onPressed: () async {
                  bool check = false;
               await   showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Đổi mật khẩu"),
                        content: Text("Bạn có muốn đổi mật khẩu mới"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Hủy")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                check = true;
                              },
                              child: Text("Xác nhận"))
                        ],
                      );
                    },
                  );
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          height: h * 0.3,
                          child: Center(
                            child: Lottie.asset("assets/lottie/loading.json"),
                          ),
                        ),
                      );
                    },
                  );
                  if (check == true) {
                       if(old_pass_controller.text==""||new_pass_controller.text==""||renew_pass_controller.text==""){
                         Navigator.pop(context);
                        CherryToast.warning(title: Text("Vui lòng kiểm tra dữ liệu")).show(context);
                       }
                       else{
                              SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? old_pass = await prefs.getString('password');
                    Navigator.pop(context);
                    if (old_pass_controller.text == old_pass) {
                      if (new_pass_controller.text == renew_pass_controller.text) {
                        CherryToast.success(
                                title: Text("Cập nhật mật khẩu thành công"))
                            .show(context);
                            setState(() {
                              new_pass_controller.text="";
                              old_pass_controller.text="";
                              renew_pass_controller.text="";
                            });
                      } else {
                        CherryToast.error(
                                title: Text("Nhập lại mật khẩu không khớp"))
                            .show(context);
                      }
                    } else {
                      CherryToast.error(title: Text("Mật khẩu cũ không đúng"))
                          .show(context);
                    }
                       }
                      check = false;
                  }
                
                },
                child: const Text(
                  'Cập nhật',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
