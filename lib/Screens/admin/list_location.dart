import 'package:flutter/material.dart';
import 'package:personnel_5chaumedia/Models/datauser.dart';
import 'package:personnel_5chaumedia/Screens/admin/location_detail.dart';
import 'package:personnel_5chaumedia/Services/networks.dart';
import 'package:personnel_5chaumedia/Widgets/nextscreen.dart';
import 'package:provider/provider.dart';


class List_Location extends StatefulWidget {
  const List_Location({super.key});

  @override
  State<List_Location> createState() => _List_LocationState();
}

class _List_LocationState extends State<List_Location> {
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
        title: Text("Danh sách phòng ban"),
        centerTitle: true,
      ),
      body: FutureBuilder(
              future: NetworkRequest().getLocation_Admin(
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
                          subtitle: Text("Phạm vi chấm công: ${snapshot.data[index]['meter']}m",style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            Next_Screeen().push(context, Set_Location(data:snapshot.data[index],));
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
