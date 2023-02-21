class ForgotPwdModel{
  String email;
  int phoneNumber;


  ForgotPwdModel({required this.email, required this.phoneNumber});

  factory ForgotPwdModel.fromJson(Map<String, dynamic> json) {
    return ForgotPwdModel(
        email: json['email'],
        phoneNumber: json['phonenumber']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['phonenumber'] = this.phoneNumber;
    return data;
  }



}