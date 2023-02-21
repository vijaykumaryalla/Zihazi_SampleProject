class ReviewModel {
  ReviewModel({
    required this.successCode,
    required this.message,});

  ReviewModel.fromJson(dynamic json) {
    successCode = json['SuccessCode'];
    message = json['message'];
  }
  late int successCode;
  late String message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SuccessCode'] = successCode;
    map['message'] = message;
    return map;
  }

}