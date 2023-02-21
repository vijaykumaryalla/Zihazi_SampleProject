class LoginResponse {
  LoginResponse({
    required this.successCode,
    required this.message,
    this.token,
    this.os,
    required this.data,
  });
  late final int successCode;
  late final String message;
  late final String? token;
  late final String? os;
  late final Data? data;

  LoginResponse.fromJson(Map<String, dynamic> json){
    successCode = json['SuccessCode'];
    message = json['message'];
    token = json['token'];
    os = json['os'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['SuccessCode'] = successCode;
    _data['message'] = message;
    _data['token'] = token;
    _data['os'] = os;
    _data['data'] = data == null? '' : data!.toJson() ;
    return _data;
  }
}

class Data {
  Data({
    this.userid,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
  });
  late final String? userid;
  late final String? firstname;
  late final String? lastname;
  late final String? email;
  late final String? phone;

  Data.fromJson(Map<String, dynamic> json){
    userid = json['userid'];
    firstname = json['first name'];
    lastname = json['last name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userid'] = userid;
    _data['first name'] = firstname;
    _data['last name'] = lastname;
    _data['email'] = email;
    _data['phone'] = phone;
    return _data;
  }
}