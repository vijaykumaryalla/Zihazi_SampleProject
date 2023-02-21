

import '../../dashboard/model/categoryproductsuccessmodel.dart';

class CategorySearchSuccessModel {
  CategorySearchSuccessModel({
    required this.successCode,
    required this.message,
    required this.data,
  });
  late final int successCode;
  late final String message;
  late final Data data;

  CategorySearchSuccessModel.fromJson(Map<String, dynamic> json){
    successCode = json['SuccessCode'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['SuccessCode'] = successCode;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.products,
  });
  late final List<Products> products;

  Data.fromJson(Map<String, dynamic> json){
    products = List.from(json['Products']).map((e)=>Products.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Products'] = products.map((e)=>e.toJson()).toList();
    return _data;
  }
}
