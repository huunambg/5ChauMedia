import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:personnel_5chaumedia/Models/datauser.dart';
import 'package:personnel_5chaumedia/Services/networks.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class List_MAC extends StatefulWidget {
  const List_MAC({super.key});

  @override
  State<List_MAC> createState() => _List_MACState();
}

class _List_MACState extends State<List_MAC> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Danh sách Wifi điểm danh"),
        centerTitle: true,
      ),
      body: context.read<DataUser_Provider>().id_company() == ""
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder(
              future: NetworkRequest().get_Mac_admin(
                  context.read<DataUser_Provider>().id_company()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text("${snapshot.data[index]['name']}",style: TextStyle(color: Colors.white),),
                          subtitle: Text("${snapshot.data[index]['address']}",style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            bool check_click = false;
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title:
                                      Text("${snapshot.data[index]['name']}"),
                                  content: Text("Bạn có muốn xóa Wifi trên ?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        check_click = true;
                                        Navigator.pop(context);
                                      },
                                      child: Text("Xóa"),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Quay lại"))
                                  ],
                                );
                              },
                            );
                            if (check_click == true) {
                              if (await NetworkRequest().delete_MAC_WIFI(
                                      snapshot.data[index]['id'].toString()) ==
                                  "Success") {
                                CherryToast.success(
                                        title: Text("Xóa thành công Wifi"))
                                    .show(context);
                                setState(() {});
                              } else {
                                CherryToast.success(
                                        title: Text("Xóa thất bại Wifi"))
                                    .show(context);
                              }
                            }
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
    );
  }
}
