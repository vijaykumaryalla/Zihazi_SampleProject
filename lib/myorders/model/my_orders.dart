import 'package:intl/intl.dart';

class MyOrders {
  MyOrders({
    required this.successCode,
    required this.message,
    required this.data,
  });
  late final int successCode;
  late final String message;
  late final List<Orders> data;

  MyOrders.fromJson(Map<String, dynamic> json){
    successCode = json['SuccessCode'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Orders.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['SuccessCode'] = successCode;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Orders {
  Orders({
    required this.orderName,
    required this.orderId,
    required this.deliveryDate,
    required this.noOfItems,
    required this.status,
  });
  late final String orderName;
  late final String orderId;
  late final String deliveryDate;
  late final int noOfItems;
  late final String status;

  Orders.fromJson(Map<String, dynamic> json){
    orderName = json['orderId'];
    orderId = json['Orderid'];
    deliveryDate = getLocalDate(json['deliveryDate']);
    noOfItems = json['noOfItems'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['orderId'] = orderName;
    _data['Orderid'] = orderId;
    _data['deliveryDate'] = deliveryDate;
    _data['noOfItems'] = noOfItems;
    _data['Status'] = status;
    return _data;
  }

  getLocalDate(String date) {
    var dateFormat = DateFormat("dd-MM-yyyy");
    var utcDate = dateFormat.format(DateTime.parse(date));
    var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
    return dateFormat.format(DateTime.parse(localDate));
  }
}