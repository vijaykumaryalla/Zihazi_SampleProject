
import '../../dashboard/model/categoryproductsuccessmodel.dart';

/// SuccessCode : 200
/// message : "Transaction was Successful"
/// data : {"categoery":[{"subCategories":{"catName":"Lightning PD Cables","catId":"8","viewId":"1","Products":[{"prodId":"36","prodName":" Lectronic Premium TPE Charging/Sync. Cable type C-To Lightning ,MFI certified, Fast Charging PD ,1M, Black","prodAmount":"59.000000","prodImage":"https://smvatech.in/ecommerce/pub/media/catalog/product/cache/7487b891c5ac49a8eb3175bc1d024c18/0/1/01-_1___2083136114.png","isFavorite":false},{"prodId":"39","prodName":"Lectronic Premium Nylon Braided Charging/Sync. Cable type C-To Lightning ,MFI certified, Fast Charging PD ,1.5M, Black . Heavy duty Zinc Alloy Metal housing","prodAmount":"89.000000","prodImage":"https://smvatech.in/ecommerce/pub/media/catalog/product/cache/7487b891c5ac49a8eb3175bc1d024c18/0/5/05__1647116038.png","isFavorite":false},{"prodId":"108","prodName":"MFI Lightning To Type-C Fast Charging Cable | Metal | 1.5M | Black","prodAmount":"99.000000","prodImage":"https://smvatech.in/ecommerce/pub/media/catalog/product/cache/7487b891c5ac49a8eb3175bc1d024c18/c/_/c_to_l_lc-016-blk.png","isFavorite":false}]}}]}

class ProdFromSubCatSuccessModel {
  ProdFromSubCatSuccessModel({
    int? successCode,
    String? message,
    Data? data,}){
    _successCode = successCode;
    _message = message;
    _data = data;
  }

  ProdFromSubCatSuccessModel.fromJson(dynamic json) {
    _successCode = json['SuccessCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? _successCode;
  String? _message;
  Data? _data;

  int? get successCode => _successCode;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SuccessCode'] = _successCode;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// categoery : [{"subCategories":{"catName":"Lightning PD Cables","catId":"8","viewId":"1","Products":[{"prodId":"36","prodName":" Lectronic Premium TPE Charging/Sync. Cable type C-To Lightning ,MFI certified, Fast Charging PD ,1M, Black","prodAmount":"59.000000","prodImage":"https://smvatech.in/ecommerce/pub/media/catalog/product/cache/7487b891c5ac49a8eb3175bc1d024c18/0/1/01-_1___2083136114.png","isFavorite":false},{"prodId":"39","prodName":"Lectronic Premium Nylon Braided Charging/Sync. Cable type C-To Lightning ,MFI certified, Fast Charging PD ,1.5M, Black . Heavy duty Zinc Alloy Metal housing","prodAmount":"89.000000","prodImage":"https://smvatech.in/ecommerce/pub/media/catalog/product/cache/7487b891c5ac49a8eb3175bc1d024c18/0/5/05__1647116038.png","isFavorite":false},{"prodId":"108","prodName":"MFI Lightning To Type-C Fast Charging Cable | Metal | 1.5M | Black","prodAmount":"99.000000","prodImage":"https://smvatech.in/ecommerce/pub/media/catalog/product/cache/7487b891c5ac49a8eb3175bc1d024c18/c/_/c_to_l_lc-016-blk.png","isFavorite":false}]}}]

class Data {
  Data({
    List<Categoery>? categoery,}){
    _categoery = categoery;
  }

  Data.fromJson(dynamic json) {
    if (json['categoery'] != null) {
      _categoery = [];
      json['categoery'].forEach((v) {
        _categoery?.add(Categoery.fromJson(v));
      });
    }
  }
  List<Categoery>? _categoery;

  List<Categoery>? get categoery => _categoery;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_categoery != null) {
      map['categoery'] = _categoery?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// subCategories : {"catName":"Lightning PD Cables","catId":"8","viewId":"1","Products":[{"prodId":"36","prodName":" Lectronic Premium TPE Charging/Sync. Cable type C-To Lightning ,MFI certified, Fast Charging PD ,1M, Black","prodAmount":"59.000000","prodImage":"https://smvatech.in/ecommerce/pub/media/catalog/product/cache/7487b891c5ac49a8eb3175bc1d024c18/0/1/01-_1___2083136114.png","isFavorite":false},{"prodId":"39","prodName":"Lectronic Premium Nylon Braided Charging/Sync. Cable type C-To Lightning ,MFI certified, Fast Charging PD ,1.5M, Black . Heavy duty Zinc Alloy Metal housing","prodAmount":"89.000000","prodImage":"https://smvatech.in/ecommerce/pub/media/catalog/product/cache/7487b891c5ac49a8eb3175bc1d024c18/0/5/05__1647116038.png","isFavorite":false},{"prodId":"108","prodName":"MFI Lightning To Type-C Fast Charging Cable | Metal | 1.5M | Black","prodAmount":"99.000000","prodImage":"https://smvatech.in/ecommerce/pub/media/catalog/product/cache/7487b891c5ac49a8eb3175bc1d024c18/c/_/c_to_l_lc-016-blk.png","isFavorite":false}]}

class Categoery {
  Categoery({
    SubCategories? subCategories,}){
    _subCategories = subCategories;
  }

  Categoery.fromJson(dynamic json) {
    _subCategories = json['subCategories'] != null ? SubCategories.fromJson(json['subCategories']) : null;
  }
  SubCategories? _subCategories;

  SubCategories? get subCategories => _subCategories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_subCategories != null) {
      map['subCategories'] = _subCategories?.toJson();
    }
    return map;
  }

}

/// catName : "Lightning PD Cables"
/// catId : "8"
/// viewId : "1"
/// Products : [{"prodId":"36","prodName":" Lectronic Premium TPE Charging/Sync. Cable type C-To Lightning ,MFI certified, Fast Charging PD ,1M, Black","prodAmount":"59.000000","prodImage":"https://smvatech.in/ecommerce/pub/media/catalog/product/cache/7487b891c5ac49a8eb3175bc1d024c18/0/1/01-_1___2083136114.png","isFavorite":false},{"prodId":"39","prodName":"Lectronic Premium Nylon Braided Charging/Sync. Cable type C-To Lightning ,MFI certified, Fast Charging PD ,1.5M, Black . Heavy duty Zinc Alloy Metal housing","prodAmount":"89.000000","prodImage":"https://smvatech.in/ecommerce/pub/media/catalog/product/cache/7487b891c5ac49a8eb3175bc1d024c18/0/5/05__1647116038.png","isFavorite":false},{"prodId":"108","prodName":"MFI Lightning To Type-C Fast Charging Cable | Metal | 1.5M | Black","prodAmount":"99.000000","prodImage":"https://smvatech.in/ecommerce/pub/media/catalog/product/cache/7487b891c5ac49a8eb3175bc1d024c18/c/_/c_to_l_lc-016-blk.png","isFavorite":false}]

class SubCategories {
  SubCategories({
    String? catName,
    String? catId,
    String? viewId,
    List<Products>? products,}){
    _catName = catName;
    _catId = catId;
    _viewId = viewId;
    _products = products;
  }

  SubCategories.fromJson(dynamic json) {
    _catName = json['catName'];
    _catId = json['catId'];
    _viewId = json['viewId'];
    _lastPageNumber = json['lastPageNumber'];
    if (json['Products'] != null) {
      _products = [];
      json['Products'].forEach((v) {
        _products?.add(Products.fromJson(v));
      });
    }
  }
  String? _catName;
  String? _catId;
  String? _viewId;
  int? _lastPageNumber;
  List<Products>? _products;

  String? get catName => _catName;
  String? get catId => _catId;
  String? get viewId => _viewId;
  int? get lastPageNumber => _lastPageNumber;
  List<Products>? get products => _products;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['catName'] = _catName;
    map['catId'] = _catId;
    map['viewId'] = _viewId;
    map['lastPageNumber'] = _lastPageNumber;
    if (_products != null) {
      map['Products'] = _products?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// prodId : "36"
/// prodName : " Lectronic Premium TPE Charging/Sync. Cable type C-To Lightning ,MFI certified, Fast Charging PD ,1M, Black"
/// prodAmount : "59.000000"
/// prodImage : "https://smvatech.in/ecommerce/pub/media/catalog/product/cache/7487b891c5ac49a8eb3175bc1d024c18/0/1/01-_1___2083136114.png"
/// isFavorite : false
