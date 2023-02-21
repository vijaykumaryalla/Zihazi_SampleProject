class SignupResponse {
  SignupResponse({
    required this.successCode,
    required this.message,
  });
  late final int successCode;
  late final String message;
  late final Data data;

  SignupResponse.fromJson(Map<String, dynamic> json){
    successCode = json['SuccessCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : Data();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['SuccessCode'] = successCode;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({

    this.userid = 0,
    this.firstname = '',
    this.lastname = '',
    this.email = '',
    this.token = ''
  });
  late final int userid;
  late final String firstname;
  late final String lastname;
  late final String email;
  late final String token;

  Data.fromJson(Map<String, dynamic> json){
    userid = json['userid'] ?? 0;
    token =  json['token'] ?? "";
    // firstname = json['first name'];
    // lastname = json['last name'];
    // email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userid'] = userid;
    _data['first name'] = firstname;
    _data['last name'] = lastname;
    _data['email'] = email;
    return _data;
  }
}