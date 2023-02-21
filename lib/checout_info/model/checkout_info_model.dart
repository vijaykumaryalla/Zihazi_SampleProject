class CheckoutUserAddressListModel {
  late int successCode;
  late String message;
  late List<Data> data;

  CheckoutUserAddressListModel({required this.successCode,required this.message,required this.data});

  CheckoutUserAddressListModel.fromJson(Map<String, dynamic> json) {
    successCode = json['SuccessCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SuccessCode'] = this.successCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
 late String addressId="";
 late String firstname="";
 late String lastname="";
 late String country="";
 late String postcode="";
 late String city="";
 late List<String> location=[];
 late String phone="";
 late String company="";
 late String state="";
 late String isDefaultBilling="";
 late String isDefaultShipping="";

 Data(
      {required this.addressId,
        required this.firstname,
        required  this.lastname,
        required this.country,
        required this.postcode,
        required this.city,
        required this.location,
        required this.phone,
        required this.company,
        required this.state,
        required this.isDefaultBilling,
        required this.isDefaultShipping});

 Data.fromJson(Map<String, dynamic> json) {
    addressId = json['addressId'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    country = json['country'];
    postcode = json['postcode'];
    city = json['city'];
    location = json['location'].cast<String>();
    phone = json['phone'];
    company = json['company']?? "";
    state = json['state'];
    isDefaultBilling = json['isDefaultBilling'];
    isDefaultShipping = json['isDefaultShipping'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressId'] = this.addressId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['country'] = this.country;
    data['postcode'] = this.postcode;
    data['city'] = this.city;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['company'] = this.company;
    data['state'] = this.state;
    data['isDefaultBilling'] = this.isDefaultBilling;
    data['isDefaultShipping'] = this.isDefaultShipping;
    return data;
  }
}