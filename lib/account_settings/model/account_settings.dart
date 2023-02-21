class AccountSettings {
  AccountSettings({
    required this.successCode,
    required this.message,
    required this.data,
  });

  AccountSettings.fromJson(dynamic json) {
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
    map['data'] = data.toJson();
    return map;
  }
}

class Data {
  Data({
    required this.profileImage,
    required this.displayName,
    required this.email,
    required this.firstname,
    required this.mobilenumber,
    required this.lastname,
    required this.gender,
    required this.notification,
    required this.billingAddress,
  });

  Data.fromJson(dynamic json) {
    profileImage = json['profileImage'] ?? "";
    displayName = json['displayName'] ?? "";
    email = json['email'] ?? "";
    mobilenumber = json['mobilenumber'] ?? "";
    firstname = json['name'] ?? "";
    lastname = json['lastname'] ?? "";
    gender = json['Gender'] ?? "";
    notification = json['notification'] ?? "";
    billingAddress =  json["billingAddress"] is List ? BillingAddress(address: [], company: "", state: "") : json['billingAddress'] != null ? BillingAddress.fromJson(json['billingAddress']): BillingAddress(address: [], company: "", state: "");
  }

  late String profileImage;
  late String displayName;
  late String email;
  late String firstname;
  late String lastname;
  late String gender;
  late String notification;
  late String mobilenumber;
  late BillingAddress billingAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profileImage'] = profileImage;
    map['displayName'] = displayName;
    map['email'] = email;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['Gender'] = gender;
    map['notification'] = notification;
    map['billingAddress'] = billingAddress.toJson();
    return map;
  }
}

class BillingAddress {
  BillingAddress({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.country = "",
    this.postcode = "",
    this.city = "",
    required this.address,
    this.phone = "",
    required this.company,
    required this.state,
  });

  BillingAddress.fromJson(dynamic json) {
    id = json['id'] ?? "";
    firstName = json['name'] ?? "";
    country = json['country'] ?? "";
    postcode = json['postcode'] ?? "";
    city = json['city'] ?? "";
    address = json['address'] != null ? json['address'].cast<String>() : [];
    phone = json['phone']?? "";
    company = json['company']?? "";
    state = json['state']?? "";
  }

  late String id;
  late String firstName;
  late String lastName;
  late String country;
  late String postcode;
  late String city;
  late List<String> address;
  late String phone;
  late String company;
  late String state;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['country'] = country;
    map['postcode'] = postcode;
    map['city'] = city;
    map['address'] = address;
    map['phone'] = phone;
    map['company'] = company;
    map['state'] = state;
    return map;
  }
}
