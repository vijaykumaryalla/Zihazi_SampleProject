class LoginFailureResponse {
  LoginFailureResponse({
    required this.successCode,
    required this.message,
    required this.data,
  });
  late final int successCode;
  late final String message;
  late final String data;

  LoginFailureResponse.fromJson(Map<String, dynamic> json){
    successCode = json['SuccessCode'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['SuccessCode'] = successCode;
    _data['message'] = message;
    _data['data'] = data;
    return _data;
  }
}