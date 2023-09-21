import 'dart:convert';
import 'package:http/http.dart' as http;
import '/constants.dart';

class NetworkRequest {
  Future<String> rollcall_personnel(String? id, String? place) async {
    String message;
    print("dang diem danh");
    final response = await http.post(Uri.parse('${URL_ROLLCALL_PERSONNEL}$id'),
        body: {'place': "$place"});
    message = jsonDecode(response.body)['message'];
    print("Rollcall: $message");
    return message;
  }

  Future<dynamic> Detaill_Rollcall_By_Month(String? id) async {
    final response = await http.get(
      Uri.parse('${URL_STATISTICAL_BY_MONTH}$id'),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data2'];
      //print("Length : $data");
      return data;
    } else
      return "Error";
  }

  Future<dynamic> Detail_Rollcall_By_Month_Year(
      String? id, int? month, int? year) async {
    final response = await http.post(
      Uri.parse('${URL_STATISTICAL_BY_MONTH_YEAR}$id'),
      body: {'date': '$year-$month'},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data2'];
      // print("Length : $data");
      return data;
    } else
      return "Error";
  }

  Future<dynamic> Statistical_By_Month(String? id) async {
    final response = await http.get(
      Uri.parse('${URL_STATISTICAL_BY_MONTH}$id'),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      //  print(data);
      return data;
    } else
      return "Error";
  }

  Future<dynamic> Statistical_By_Month_Year(
      String? id, int? month, int? year) async {
    final response = await http.post(
      Uri.parse('${URL_STATISTICAL_BY_MONTH_YEAR}$id'),
      body: {'date': '$year-$month'},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      return data;
    } else
      return "Error";
  }

  Future getLocation(String? id) async {
    final response = await http.get(Uri.parse('$URL_GETLOCATION/$id'));
    print("GET LOCATION : ${response.statusCode}");
    //   print(jsonDecode(response.body)['personnel'][0]);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 202) {
      return "Success";
    } else {
      return "Error";
    }
  }

  Future getLocation_Admin(String? id) async {
    final response = await http.get(Uri.parse('$URL_GETLOCATION_ADMIN/$id'));
    print(jsonDecode(response.body)['personnel']);
    return jsonDecode(response.body)['personnel'];
  }

  Future update_Location_Admin(String? id, String? name, String? lat,
      String? long, String? meter) async {
    final response = await http.put(Uri.parse('$URL_UPDATE_LOCATION_ADMIN/$id'),
        body: {
          "name": name,
          "latitude": lat,
          "longitude": long,
          "meter": meter
        });
    print(jsonDecode(response.body)['status']);
    return jsonDecode(response.body)['status'];
  }

  Future<dynamic> get_Mac_admin(String? id) async {
    final response = await http.get(Uri.parse('$URL_GET_MAC_ADMIN$id'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(jsonDecode(response.body)['mac']);
      return jsonDecode(response.body)['mac'];
    } else {
      return [];
    }
  }

  Future<dynamic> getdataRollcall_detail_day_one_day(
      String? month_year, String? id_per, String? day) async {
    final response = await http.get(Uri.parse(
        "${URL_GET_ROLLCALL_DETAIL_DAY_ONE_DAY}$month_year/$id_per/$day"));
    if (response.statusCode == 200) {
      //  print(jsonDecode(response.body)["data"]);
      return jsonDecode(response.body)["data"];
    } else
      return null;
  }

  Future<dynamic> fetchData_Notification(String? id) async {
    final response = await http.get(Uri.parse('$URL_GET_NOTIFICATION/$id'));

    if (response.statusCode == 200) {
      //   print(List.from(jsonDecode(response.body)['data'].reversed.toList()));
      return List.from(jsonDecode(response.body)['data'].reversed.toList());
    } else if (response.statusCode == 404) {
      return [];
    }
  }

  Future<int> get_count_notification_not_check(String? id) async {
    final response =
        await http.get(Uri.parse('$URL_GET_COUNT_NOTIFICATION_NOT_CHECKED$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['count'];
    } else {
      return 0;
    }
  }

  Future<dynamic> fetch_Data_Notification_Checked(String? id) async {
    final response =
        await http.get(Uri.parse('${URL_GET_NOTIFICATION_CHECKED}$id')); //
    if (response.statusCode == 200) {
      //   print(jsonDecode(response.body)['data']);
      return jsonDecode(response.body)['data'];
    } else {
      // print("Error");
      return [];
    }
  }

  Future<void> set_Data_Notification_Checked(String? id_per, int? id_n) async {
    final response = await http
        .get(Uri.parse('${URL_SET_NOTIFICATION_CHECKED}$id_per/$id_n')); //
    if (response.statusCode == 200) {
      //   print("Succes");
    } else {
      //   print("Error");
    }
  }

  Future<String> get_Text_QR_Rollcall(String? id) async {
    final response = await http.get(Uri.parse('$URL_GET_TEXT_QR_ROLLCALL/$id'));
    if (response.statusCode == 200) {
      // print("SUCCESS");
      //  print(jsonDecode(response.body));
      return jsonDecode(response.body)['data']['content'];
    } else {
      // print("ERROR");
      return "ERROR";
    }
  }

  Future<String> get_last_rollcall(String? id_personnel) async {
    final response =
        await http.get(Uri.parse('${URL_GET_LAST_ROLLCALL}$id_personnel'));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body)['data']);
      return jsonDecode(response.body)['data'].toString();
    } else {
      return "Error";
    }
  }

  Future<int> get_break_time(String? id) async {
    final response = await http.get(Uri.parse('${URL_GET_BREAK_TIME}/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'][0]['time'];
    } else {
      return 10000;
    }
  }

  Future<dynamic> get_MAC_WIFI(String? id) async {
    final response =
        await http.get(Uri.parse('${URL_GET_WIFI_MAC_ADDRESS}/$id'));
    print("GET WIFI : ${response.statusCode}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['mac'];
    } else if (response.statusCode == 202) {
      return "Success";
    } else {
      return "Error";
    }
  }

  Future<dynamic> add_MAC_WIFI(String? id, String? wifi, String? mac) async {
    final response = await http.post(Uri.parse('${URL_ADD_MAC_ADMIN}$id'),
        body: {"name": wifi, "address": mac});
    if (response.statusCode == 200) {
      return "Success";
    } else {
      return "Error";
    }
  }

  Future<dynamic> delete_MAC_WIFI(String? id) async {
    final response =
        await http.delete(Uri.parse('${URL_DET_MAC_ADMIN}$id'), body: {});
    if (response.statusCode == 200) {
      return "Success";
    } else {
      return "Error";
    }
  }

  Future<String> delete_User(String? id) async {
    final response = await http.delete(Uri.parse("$URL_DET_USER$id"));
    if (response.statusCode == 200) {
      return "Success";
    } else {
      return "Error";
    }
  }

  Future<dynamic> edit_img(String? id, String? img) async {
    final response = await http.put(Uri.parse('${URL_EDIT_EDITIMG}$id/editimg'),
        body: {"img": "$img"});
    print("Status IMG ${response.statusCode}");
    if (jsonDecode(response.body)['status'] == 200) {
      return "Success";
    } else {
      return "Error";
    }
  }

  Future<String> get_base64_img(String? id) async {
    final response = await http.get(Uri.parse('${URL_GET_BASE64_IMG}$id'));
    print("Get IMG :${response.statusCode}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['image'];
    } else {
      return "Error";
    }
  }

  Future<String> edit_ProfileS(String? id, String? name, String? email,
      String? phone, String? pass) async {
    final response = await http.put(Uri.parse('${URL_EDIT_PROFILE}$id/edit'),
        body: {
          "name": "$name",
          "email": "$email",
          "phone": "$phone",
          "password": "$pass"
        });
    print("Edit Profile :${response.statusCode}");
    if (response.statusCode == 200) {
      return "Success";
    } else {
      return "Error";
    }
  }
}
