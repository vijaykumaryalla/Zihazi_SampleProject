class AddAddress {
  AddAddress({
    required this.successCode,
    required this.message,
    required this.data,
  });

  AddAddress.fromJson(dynamic json) {
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
    required this.addressId,
    required this.firstname,
    required this.lastname,
    required this.country,
    required this.postcode,
    required this.city,
    required this.address,
    required this.state,
    required this.isDefaultBilling,
    required this.isDefaultShipping,
    required this.phone,
    required this.company,
  });

  Data.fromJson(dynamic json) {
    addressId = json['addressId'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    country = json['country'];
    postcode = json['postcode'];
    city = json['city'];
    address = json['address'];
    state = json['state'];
    isDefaultBilling = json['isDefaultBilling'];
    isDefaultShipping = json['isDefaultShipping'];
    phone = json['phone'];
    company = json['company'];
  }
  late String addressId;
  late String firstname;
  late String lastname;
  late String country;
  late String postcode;
  late String city;
  late String address;
  late String state;
  late String isDefaultBilling;
  late String isDefaultShipping;
  late String phone;
  late String company;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['addressId'] = addressId;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['country'] = country;
    map['postcode'] = postcode;
    map['city'] = city;
    map['address'] = address;
    map['state'] = state;
    map['isDefaultBilling'] = isDefaultBilling;
    map['isDefaultShipping'] = isDefaultShipping;
    map['phone'] = phone;
    map['company'] = company;
    return map;
  }
}
