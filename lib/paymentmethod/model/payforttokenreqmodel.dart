class PayFortTokenReqModel {
  PayFortTokenReqModel({
    required this.serviceCommand,
    required this.accessCode,
    required this.merchantIdentifier,
    required this.language,
    required this.deviceId,
    required this.signature,
  });
  late final String serviceCommand;
  late final String accessCode;
  late final String merchantIdentifier;
  late final String language;
  late final String deviceId;
  late final String signature;

  PayFortTokenReqModel.fromJson(Map<String, dynamic> json){
    serviceCommand = json['service_command'];
    accessCode = json['access_code'];
    merchantIdentifier = json['merchant_identifier'];
    language = json['language'];
    deviceId = json['device_id'];
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['service_command'] = serviceCommand;
    _data['access_code'] = accessCode;
    _data['merchant_identifier'] = merchantIdentifier;
    _data['language'] = language;
    _data['device_id'] = deviceId;
    _data['signature'] = signature;
    return _data;
  }
}