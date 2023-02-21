class CreateOrderResModel {
  CreateOrderResModel({
    required this.SuccessCode,
    required this.message,
    required this.data,
  });
  late final int SuccessCode;
  late final String message;
  late final Data data;

  CreateOrderResModel.fromJson(Map<String, dynamic> json){
    SuccessCode = json['SuccessCode'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['SuccessCode'] = SuccessCode;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.incrementId,
    required this.orderId,
  });
  late final String incrementId;
  late final String orderId;

  Data.fromJson(Map<String, dynamic> json){
    incrementId = json['incrementId'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['incrementId'] = incrementId;
    _data['orderId'] = orderId;
    return _data;
  }
}