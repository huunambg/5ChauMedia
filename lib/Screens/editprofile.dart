import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:personnel_5chaumedia/Models/datauser.dart';
import 'package:personnel_5chaumedia/Services/networks.dart';
import 'package:personnel_5chaumedia/constants.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Edit_Profile_Screen extends StatefulWidget {
  const Edit_Profile_Screen({super.key});

  @override
  State<Edit_Profile_Screen> createState() => _Edit_Profile_ScreenState();
}

class _Edit_Profile_ScreenState extends State<Edit_Profile_Screen> {
  final phone_controller = TextEditingController();
  final name_controller = TextEditingController();
  final email_controller = TextEditingController();
  String imagepath = "";
  String base64String = "";
  final ImagePicker imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();
    set_data();
  }

  void set_data() {
    name_controller.text = context.read<DataUser_Provider>().name_personnel();
    email_controller.text = context.read<DataUser_Provider>().email();
    phone_controller.text = context.read<DataUser_Provider>().phone();
  }

  void openImage() async {
    try {
      var pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imagepath = pickedFile.path;
        File imagefile = File(imagepath);
        Uint8List imagebytes = await imagefile.readAsBytes();
        base64String = base64.encode(imagebytes);
        context.read<DataUser_Provider>().set_base64_img_edit(base64String);
        update_avatar();
      } else {
        print('No image is selected');
      }
    } catch (e) {
      print('No image is selected');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7F67BE),
        title: Text("Chỉnh sửa thông tin"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: Container(
                      height: h * 0.2,
                      width: h * 0.2,
                      child:
                          context.read<DataUser_Provider>().base64_img_edit() !=
                                      "Error" &&
                                  context
                                          .read<DataUser_Provider>()
                                          .base64_img_edit() !=
                                      ""
                              ? Image(
                                  image: MemoryImage(base64Decode(context
                                      .watch<DataUser_Provider>()
                                      .base64_img_edit())),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset("assets/icons/ic_appbar.png",
                                  fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                        onPressed: () {
                          openImage();
                        },
                        icon: Icon(Icons.save)),
                  )
                ],
              ),
              SizedBox(height: 20),
              ItemEdit(
                controller: name_controller,
                titile: "Tên người dùng",
              ),
              SizedBox(height: 10),
              ItemEdit(
                controller: email_controller,
                titile: "Email",
              ),
              SizedBox(height: 10),
              ItemEdit(
                controller: phone_controller,
                titile: "Số điện thoại",
              ),
              SizedBox(height: 20),
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
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Thông tin cá nhân"),
                          content: Text("Bạn có muốn cập nhật thông tin"),
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
                    if (check == true) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              height: h * 0.3,
                              child: Center(
                                child:
                                    Lottie.asset("assets/lottie/loading.json"),
                              ),
                            ),
                          );
                        },
                      );
                      update_Profile();
                    }
                  },
                  child: const Text(
                    'Lưu',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> update_Profile() async {
    if (phone_controller.text != "" &&
        int.tryParse(phone_controller.text) != null &&
        email_controller.text != "" &&
        name_controller.text != "") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? pass = await prefs.getString('password');
      String? massage = await NetworkRequest()
          .edit_ProfileS(context.read<DataUser_Provider>().id_per(),name_controller.text,email_controller.text,phone_controller.text,pass);
              Navigator.pop(context);
      if (massage != "Error") {
        CherryToast.success(title: Text("Cập nhật dữ liệu thành công"))
            .show(context);

        await  prefs.setString('user_name',name_controller.text);
         await prefs.setString('email',email_controller.text);
         await prefs.setString('phone',phone_controller.text);
        
        context.read<DataUser_Provider>().set_id_name_personnel();
            
      } else {
        CherryToast.error(title: Text("Cập nhật dữ liệu thất bại"))
            .show(context);
      }
    }
  }

  Future<void> update_avatar() async {
    bool check = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ảnh đại diện"),
          content: Text("Bạn có muốn cập nhật ảnh đại diện"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<DataUser_Provider>().set_base64_img_edit(
                      context.read<DataUser_Provider>().base64_img());
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
    if (check == true) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Center(
                child: Lottie.asset("assets/lottie/loading.json"),
              ),
            ),
          );
        },
      );

      if (base64String == "") {
        Navigator.pop(context);
        CherryToast.error(title: Text("Vui lòng chọn ảnh mới")).show(context);
      } else {
        String massaging = await NetworkRequest()
            .edit_img(context.read<DataUser_Provider>().id_per(), base64String);
        Navigator.pop(context);
        if (massaging != "Error") {
          CherryToast.success(title: Text("Cập nhật ảnh đại diện thành công"))
              .show(context);
          context.read<DataUser_Provider>().set_base64_img(base64String);
        } else {
          CherryToast.error(title: Text("Cập nhật ảnh thất bại")).show(context);
        }
        check = false;
      }
    }
  }
}

class ItemEdit extends StatelessWidget {
  const ItemEdit({super.key, this.titile, this.controller});
  final controller;
  final String? titile;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: "$titile",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            15,
          ))),
    );
  }
}
