class BaseResponse<T> {
  int successCode;
  String message;
  dynamic data;

  BaseResponse({
    required this.successCode,
    required this.message,
    required this.data
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    if (T == List) {
      return BaseResponse<T>(
          successCode: json["SuccessCode"],
          message: json["message"],
          data: List<dynamic>.from(json["data"]));
    } else {
      return BaseResponse<T>(
          successCode: json["SuccessCode"],
          message: json["message"],
          data: Map<String, dynamic>.from(json["data"]));
    }
  }

  Map<String, dynamic> toJson() => {
    "SuccessCode": successCode,
    "message": message,
    "data": data,
  };
}
