class ChangePasswordModel {
  late int successCode;
  late String message;
  late List<Null> data;

  ChangePasswordModel({required this.successCode, required this.message, required this.data});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    successCode = json['SuccessCode'];
    message = json['message'];
    if (json['data'] != null) {
      data =  <Null>[];
      json['data'].forEach((v) {
        data.add((v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SuccessCode'] = this.successCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v).toList();
    }
    return data;
  }
}