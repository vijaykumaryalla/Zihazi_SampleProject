import 'package:get/get.dart';

class CategoryProductSuccessModel {
  CategoryProductSuccessModel({
    required this.SuccessCode,
    required this.message,
    required this.data,
  });
  CategoryProductSuccessModel.fromCatProdSuccess()
  ;
  late final int SuccessCode;
  late final String message;
  late final Data data;

  CategoryProductSuccessModel.fromJson(Map<String, dynamic> json){
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
    required this.category,
  });
  late final List<Category> category;

  Data.fromJson(Map<String, dynamic> json){
    category = List.from(json['categoery']).map((e)=>Category.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categoery'] = category.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Category {
  Category({
    required this.topCategories,
  });
  late final TopCategories topCategories;

  Category.fromJson(Map<String, dynamic> json){
    topCategories = TopCategories.fromJson(json['topCategories']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['topCategories'] = topCategories.toJson();
    return _data;
  }
}

class TopCategories {
  TopCategories({
    required this.catName,
    required this.catId,
    required this.products,
  });
  late final String catName;
  late final String catId;
  late final List<Products> products;

  TopCategories.fromJson(Map<String, dynamic> json){
    catName = json['catName'];
    catId = json['catId'];
    products = List.from(json['Products']).map((e)=>Products.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['catName'] = catName;
    _data['catId'] = catId;
    _data['Products'] = products.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Products {
  Products({
    required this.prodId,
    required this.prodName,
    required this.prodAmount,
    required this.price,
    required this.prodImage,
    required this.isFavorite,
  });
  late final String prodId;
  late final String prodName;
  late final String prodAmount;
  late final bool isInStock;
  late final String price;
  late final String prodImage;
  bool isFavorite=false;

  Products.fromJson(Map<String, dynamic> json){
    prodId = json['prodId'];
    prodName = json['prodName'];
    prodAmount = json['prodAmount'].toString();
    isInStock = json['is_in_stock'];
    price = json['price'];
    prodImage = json['prodImage'];
    isFavorite = json['isFavorite'];
  }



  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['prodId'] = prodId;
    _data['prodName'] = prodName;
    _data['prodAmount'] = prodAmount;
    _data['is_in_stock'] = isInStock;
    _data['price'] = price;
    _data['prodImage'] = prodImage;
    _data['isFavorite'] = isFavorite;
    return _data;
  }

}