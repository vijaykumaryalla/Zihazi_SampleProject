class ShippingAddress {
  ShippingAddress({
    required this.successCode,
    required this.message,
    required this.data,
  });

  ShippingAddress.fromJson(dynamic json) {
    successCode = json['SuccessCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(Address.fromJson(v));
      });
    }
  }
  late int successCode;
  late String message;
  late List<Address> data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SuccessCode'] = successCode;
    map['message'] = message;
    if (data != null) {
      map['data'] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Address {
  Address({
    required this.addressId,
    required this.firstname,
    required this.lastname,
    required this.country,
    required this.postcode,
    required this.city,
    required this.location,
    required this.phone,
    required this.company,
    required this.state,
    required this.isDefaultBilling,
    required this.isDefaultShipping,
  });

  Address.fromJson(dynamic json) {
    addressId = json['addressId'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    country = json['country'];
    postcode = json['postcode'];
    city = json['city'];
    location = json['location'] != null ? json['location'].cast<String>() : [];
    phone = json['phone'];
    company = json['company'] ?? "";
    state = json['state'] ?? "";
    isDefaultBilling = json['isDefaultBilling'];
    isDefaultShipping = json['isDefaultShipping'];
  }
  late String addressId;
  late String firstname;
  late String lastname;
  late String country;
  late String postcode;
  late String city;
  late List<String> location;
  late String phone;
  late String? company;
  late String? state;
  late String isDefaultBilling;
  late String isDefaultShipping;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['addressId'] = addressId;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['country'] = country;
    map['postcode'] = postcode;
    map['city'] = city;
    map['location'] = location;
    map['phone'] = phone;
    map['company'] = company;
    map['state'] = state;
    map['isDefaultBilling'] = isDefaultBilling;
    map['isDefaultShipping'] = isDefaultShipping;
    return map;
  }
}
