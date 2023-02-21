class BaseFailureModel {
  BaseFailureModel({
    required this.responseCode,
    required this.message,
    required this.data,
  });
  late final int responseCode;
  late final String message;
  late final String data;

  BaseFailureModel.fromJson(Map<String, dynamic> json){
    responseCode = json['SuccessCode'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['SuccessCode'] = responseCode;
    _data['message'] = message;
    _data['data'] = data;
    return _data;
  }
}