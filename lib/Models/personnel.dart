
class Personnel {
  int? id;
  String? personnelId;
  String? name;
  String? phone;
  String? email;
  Personnel({this.id, this.personnelId, this.name, this.phone, this.email});

  Personnel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personnelId = json['personnel_id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['personnel_id'] = this.personnelId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    return data;
  }
}

