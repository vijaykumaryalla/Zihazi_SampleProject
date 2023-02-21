class MyAccount {
  MyAccount({
    required this.successCode,
    required this.message,
    required this.data,
  });

  MyAccount.fromJson(dynamic json) {
    successCode = json['SuccessCode'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  late int successCode;
  late String message;
  late Data data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SuccessCode'] = successCode;
    map['message'] = message;
    if (data != null) {
      map['data'] = data.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    required this.profileImage,
    required this.name,
    required this.email,
    required this.walletBalance,
  });

  Data.fromJson(dynamic json) {
    profileImage = json['profileImage'];
    name = json['name'];
    email = json['email'];
    walletBalance = json['walletBalance'];
  }

  late String profileImage;
  late String name;
  late String email;
  late String walletBalance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profileImage'] = profileImage;
    map['name'] = name;
    map['email'] = email;
    map['walletBalance'] = walletBalance;
    return map;
  }
}
