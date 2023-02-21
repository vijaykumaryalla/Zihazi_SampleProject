class PayFortTokenResModel {
  PayFortTokenResModel({
    required this.responseCode,
    required this.deviceId,
    required this.responseMessage,
    required this.serviceCommand,
    required this.sdkToken,
    required this.signature,
    required this.merchantIdentifier,
    required this.accessCode,
    required this.language,
    required this.status,
  });
  late final String responseCode;
  late final String deviceId;
  late final String responseMessage;
  late final String serviceCommand;
  late final String sdkToken;
  late final String signature;
  late final String merchantIdentifier;
  late final String accessCode;
  late final String language;
  late final String status;

  PayFortTokenResModel.fromJson(Map<String, dynamic> json){
    responseCode = json['response_code']?? "";
    deviceId = json['device_id']?? "";
    responseMessage = json['response_message']?? "";
    serviceCommand = json['service_command']?? "";
    sdkToken = json['sdk_token']?? "";
    signature = json['signature']?? "";
    merchantIdentifier = json['merchant_identifier']?? "";
    accessCode = json['access_code']?? "";
    language = json['language']?? "";
    status = json['status']?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['response_code'] = responseCode;
    _data['device_id'] = deviceId;
    _data['response_message'] = responseMessage;
    _data['service_command'] = serviceCommand;
    _data['sdk_token'] = sdkToken;
    _data['signature'] = signature;
    _data['merchant_identifier'] = merchantIdentifier;
    _data['access_code'] = accessCode;
    _data['language'] = language;
    _data['status'] = status;
    return _data;
  }
}