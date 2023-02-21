class ProductModel {
  ProductModel({
    required this.prolist,
  });
  late final List<Prolist> prolist;

  ProductModel.fromJson(Map<String, dynamic> json){
    prolist = List.from(json['prolist']).map((e)=>Prolist.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['prolist'] = prolist.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Prolist {
  Prolist({
    required this.userid,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
  });
  late final String userid;
  late final String firstname;
  late final String lastname;
  late final String email;
  late final String phone;

  Prolist.fromJson(Map<String, dynamic> json){
    userid = json['userid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userid'] = userid;
    _data['firstname'] = firstname;
    _data['lastname'] = lastname;
    _data['email'] = email;
    _data['phone'] = phone;
    return _data;
  }
}