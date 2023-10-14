import 'dart:async';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:personnel_5chaumedia/Services/networks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Set_Location extends StatefulWidget {
  const Set_Location({super.key});

  @override
  State<Set_Location> createState() => Set_LocationState();
}

class Set_LocationState extends State<Set_Location> {
  final latcontroller = TextEditingController();
  final lngcontroller = TextEditingController();
  final metercontroller = TextEditingController();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  double lat = 0;
  double long = 0;
  LatLng? latLng;
  double latitude = 0;
  double longtitude = 0;
  String? id;
  String? name;
  String? meter;
  Set<Marker> _markers = {}; // Danh sách các marker
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 19.4746,
  );

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id_company = await prefs.getString('company_id');
    var data = await NetworkRequest().getLocation_Admin(id_company);


    try{
    id = data['id'].toString();
    name = data['name'].toString();
    meter = data['meter'].toString();
    latitude = double.parse(data['latitude']);
    longtitude = double.parse(data['longitude']);


    if(latitude==0 || longtitude==0){

         Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude=position.latitude;
      longtitude=position.longitude;
    }
    _kGooglePlex = CameraPosition(
      target: LatLng(latitude, longtitude),
      zoom: 19.4746,
    );


    _markers.add(
      Marker(
        markerId: MarkerId("${latitude} + ${longtitude}"),
        position: LatLng(latitude, longtitude),
        infoWindow: InfoWindow(
          title: 'Vị trí chọn',
          snippet: 'Kinh độ: $latitude, Vĩ độ: $longtitude',
        ),
      ),
    );
    latcontroller.text = latitude.toString();
    lngcontroller.text = longtitude.toString();
    metercontroller.text=meter.toString();
    setState(() {});
    }
    catch(e){
      print("Check Bug :$e");
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude=position.latitude;
      longtitude=position.longitude;
    _kGooglePlex = CameraPosition(
      target: LatLng(latitude, longtitude),
      zoom: 19.4746,
    );


    _markers.add(
      Marker(
        markerId: MarkerId("${latitude} + ${longtitude}"),
        position: LatLng(latitude, longtitude),
        infoWindow: InfoWindow(
          title: 'Vị trí chọn',
          snippet: 'Kinh độ: $latitude, Vĩ độ: $longtitude',
        ),
      ),
    );
    meter="100";
    latcontroller.text = latitude.toString();
    lngcontroller.text = longtitude.toString();
    metercontroller.text=meter.toString();
    setState(() {});
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text("Thiết lập vị trí điểm danh"),
      ),
      body: latitude == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
            child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: GoogleMap(
                            mapType: MapType.hybrid,
                            initialCameraPosition: _kGooglePlex,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            onTap: (LatLng latLng) {
                              setState(() {
                                // Xóa tất cả các marker cũ
                                _markers.clear();
                                lat = latLng.latitude;
                                long = latLng.longitude;
                                latcontroller.text = latLng.latitude.toString();
                                lngcontroller.text = latLng.longitude.toString();
                                // Thêm marker mới vào danh sách markers
                                _markers.add(
                                  Marker(
                                    markerId: MarkerId(
                                        lat.toString() + long.toString()),
                                    position: LatLng(lat, long),
                                    infoWindow: InfoWindow(
                                      title: 'Vị trí chọn',
                                      snippet: 'Kinh độ: $long, Vĩ độ: $lat',
                                    ),
                                  ),
                                );
                              });
                            },
                            markers:
                                _markers, // Sử dụng danh sách markers để hiển thị marker trên bản đồ
                          ),
                        ),
                        Positioned(
                          top: 16.0,
                          right: 16.0,
                          child: InkWell(
                            onTap: _current,
                            child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(500),
                                    color: Colors.blue),
                                child: Icon(
                                  Icons.gps_fixed_sharp,
                                  size: 20,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    child: Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: latcontroller,
                          decoration: InputDecoration(
                              labelText: "Kinh độ",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: lngcontroller,
                          decoration: InputDecoration(
                              labelText: "Vĩ độ",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                                 SizedBox(
                          height: 10,
                        ),
                         TextField(
                          keyboardType: TextInputType.number,
                          controller: metercontroller,
                          decoration: InputDecoration(
                              labelText: "Phạm vi điểm danh (đơn vị mét)",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    height: 40,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    minWidth: 200,
                    color: Colors.green,
                    onPressed: () async {
                      int status = 0;
                      bool check_click = false;
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Lưu vị trí"),
                            content: Text("Bạn có muốn lưu vị trí trên"),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    check_click = true;
                                  },
                                  child: Text("Đồng ý")),
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
                        print("hihih");
                        status = await NetworkRequest().update_Location_Admin(id,
                            name, latcontroller.text, lngcontroller.text, metercontroller.text);
          
                        if (status == 200) {
                          CherryToast.success(
                                  title: Text("Sét vị trí mới thành công"))
                              .show(context);
                        } else if (status != 200) {
                          CherryToast.error(title: Text("Sét vị trí thất bại"))
                              .show(context);
                        }
                      }
                    },
                    child: Text(
                      "Lưu vị trí",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
          ),
    );
  }

  Future<void> _current() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
      );
    } catch (e) {
      print(e);
    }
  }
}
