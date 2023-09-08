import 'dart:async';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personnel_5chaumedia/Screens/admin/listmac.dart';
import 'package:personnel_5chaumedia/Services/networks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_scan/wifi_scan.dart';

/// Example app for wifi_scan plugin.
class Set_Mac_Wifi extends StatefulWidget {
  /// Default constructor for [Set_Mac_Wifi] widget.
  const Set_Mac_Wifi({Key? key}) : super(key: key);

  @override
  State<Set_Mac_Wifi> createState() => _Set_Mac_WifiState();
}

class _Set_Mac_WifiState extends State<Set_Mac_Wifi> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;

  bool get isStreaming => subscription != null;

  Future<void> _startScan(BuildContext context) async {
    if (shouldCheckCan) {
      // check if can-startScan
      final can = await WiFiScan.instance.canStartScan();
      if (can != CanStartScan.yes) {
        if (mounted) kShowSnackBar(context, "Cannot start scan: $can");
        return;
      }
    }

    final result = await WiFiScan.instance.startScan();
    if (mounted) kShowSnackBar(context, "Quét: $result");
    setState(() => accessPoints = <WiFiAccessPoint>[]);
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      // check if can-getScannedResults
      final can = await WiFiScan.instance.canGetScannedResults();
      // if can-not, then show error
      if (can != CanGetScannedResults.yes) {
        if (mounted)
          kShowSnackBar(context,
              "Không thể kiểm tra Wifi xung quay. Bạn phải bật vị trí để sử dụng chức năng");
        accessPoints = <WiFiAccessPoint>[];
        return false;
      }
    }
    return true;
  }

  Future<void> _getScannedResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      final results = await WiFiScan.instance.getScannedResults();
      setState(() => accessPoints = results);
    }
  }

  Future<void> _startListeningToScanResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      subscription = WiFiScan.instance.onScannedResultsAvailable
          .listen((result) => setState(() => accessPoints = result));
    }
  }

  void _stopListeningToScanResults() {
    subscription?.cancel();
    if (mounted) subscription = null;
  }

  @override
  void dispose() {
    super.dispose();
    _stopListeningToScanResults();
  }

  @override
  void initState() {
    super.initState();
    //load();
  }

  Future<void> load() async {
    _startScan(context);
    _getScannedResults(context);
  }

  // build toggle with label
  Widget _buildToggle({
    String? label,
    bool value = false,
    ValueChanged<bool>? onChanged,
    Color? activeColor,
  }) =>
      Row(
        children: [
          if (label != null) Text(label),
          Switch(value: value, onChanged: onChanged, activeColor: activeColor),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text('Thiết lập MAC'),
        actions: [
          // _buildToggle(
          //     label: "Check can?",
          //     value: shouldCheckCan,
          //     onChanged: (v) => setState(() => shouldCheckCan = v),
          //     activeColor: Colors.purple)
       IconButton(onPressed: () {
          Navigator.push(
          context, MaterialPageRoute(builder: (context) => List_MAC()));

       }, icon: Icon(Icons.list_alt))
        ],
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.perm_scan_wifi),
                    label: const Text('Quét'),
                    onPressed: () async => _startScan(context),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Hiển thị'),
                    onPressed: () async => _getScannedResults(context),
                  ),
                  _buildToggle(
                    label: "Live",
                    value: isStreaming,
                    onChanged: (shouldStream) async => shouldStream
                        ? await _startListeningToScanResults(context)
                        : _stopListeningToScanResults(),
                  ),
                ],
              ),
              const Divider(),
              Flexible(
                child: Center(
                  child: accessPoints.isEmpty
                      ? const Text("Không có kết quả Wifi")
                      : ListView.builder(
                          itemCount: accessPoints.length,
                          itemBuilder: (context, i) =>
                              _AccessPointTile(accessPoint: accessPoints[i])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccessPointTile extends StatelessWidget {
  final WiFiAccessPoint accessPoint;

  const _AccessPointTile({Key? key, required this.accessPoint})
      : super(key: key);
  Widget _buildInfo(String label, dynamic value) => Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(value.toString()))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final title = accessPoint.ssid.isNotEmpty ? accessPoint.ssid : "**EMPTY**";
    final signalIcon = accessPoint.level >= -80
        ? Icons.signal_wifi_4_bar
        : Icons.signal_wifi_0_bar;
    return Container(
      decoration: BoxDecoration(
          color: Colors.indigo, borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        leading: Icon(
          signalIcon,
          color: Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        onTap: () async {
          bool check_click=false;
        await  showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Wifi: $title",
            ),
            content: _buildInfo("MAC", accessPoint.bssid),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Quay lại")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    check_click =true;
                  },
                  child: Text("Thêm"))
            ],
          ),
        );
      if(check_click==true){
        SharedPreferences prefs =await SharedPreferences.getInstance();
        String? id_company =await prefs.getString("company_id");
        if(await NetworkRequest().add_MAC_WIFI(id_company,accessPoint.ssid,accessPoint.bssid)=="Success"){
           CherryToast.success(title: Text("Thêm Wifi điểm danh thành công")).show(context);
        }else{
              CherryToast.error(title: Text("Thêm Wifi điểm danh thất bại")).show(context);
        }
      }
        }
      ),
    );
  }
}

/// Show snackbar.
void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
