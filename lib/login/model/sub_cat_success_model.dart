/// SuccessCode : 200
/// message : "Transaction was Successful"
/// data : {"categoery":[{"subCategories":{"catName":"Lightning PD Cables","catId":"8","categoryImg":"https://smvatech.in/ecommerce/pub/media/catalog/category/heart-image.jpg"}},{"subCategories":{"catName":"Type c Cable","catId":"9","categoryImg":"https://smvatech.in/ecommerce/pub/media/catalog/category/heart-image_1.jpg"}},{"subCategories":{"catName":"Micro USB Cable","catId":"10","categoryImg":"https://smvatech.in/ecommerce/pub/media/catalog/category/heart-image_1.jpg"}},{"subCategories":{"catName":"Lightning Cable","catId":"7","categoryImg":"https://smvatech.in"}}]}

class SubCategorySuccessModel {
  SubCategorySuccessModel({
    int? successCode,
    String? message,
    Data? data,}){
    _successCode = successCode;
    _message = message;
    _data = data;
  }

  SubCategorySuccessModel.fromJson(dynamic json) {
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

/// categoery : [{"subCategories":{"catName":"Lightning PD Cables","catId":"8","categoryImg":"https://smvatech.in/ecommerce/pub/media/catalog/category/heart-image.jpg"}},{"subCategories":{"catName":"Type c Cable","catId":"9","categoryImg":"https://smvatech.in/ecommerce/pub/media/catalog/category/heart-image_1.jpg"}},{"subCategories":{"catName":"Micro USB Cable","catId":"10","categoryImg":"https://smvatech.in/ecommerce/pub/media/catalog/category/heart-image_1.jpg"}},{"subCategories":{"catName":"Lightning Cable","catId":"7","categoryImg":"https://smvatech.in"}}]

class Data {
  Data({
    List<CategoryInSubCategoryModel>? categoery,}){
    _categoery = categoery;
  }

  Data.fromJson(dynamic json) {
    if (json['categoery'] != null) {
      _categoery = [];
      json['categoery'].forEach((v) {
        _categoery?.add(CategoryInSubCategoryModel.fromJson(v));
      });
    }
  }
  List<CategoryInSubCategoryModel>? _categoery;

  List<CategoryInSubCategoryModel>? get categoery => _categoery;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_categoery != null) {
      map['categoery'] = _categoery?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// subCategories : {"catName":"Lightning PD Cables","catId":"8","categoryImg":"https://smvatech.in/ecommerce/pub/media/catalog/category/heart-image.jpg"}

class CategoryInSubCategoryModel {
  CategoryInSubCategoryModel({
    SubCategories? subCategories,}){
    _subCategories = subCategories;
  }

  CategoryInSubCategoryModel.fromJson(dynamic json) {
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
/// categoryImg : "https://smvatech.in/ecommerce/pub/media/catalog/category/heart-image.jpg"

class SubCategories {
  SubCategories({
    String? catName,
    String? catId,
    String? categoryImg,
    int? lastPageNumber
  }){
    _catName = catName;
    _catId = catId;
    _categoryImg = categoryImg;
    _lastPageNumber = lastPageNumber;
  }

  SubCategories.fromJson(dynamic json) {
    _catName = json['catName'];
    _catId = json['catId'];
    _categoryImg = json['categoryImg'];
    _categoryImg = categoryImg;
    _lastPageNumber = lastPageNumber;
  }
  String? _catName;
  String? _catId;
  String? _categoryImg;
  int? _lastPageNumber;

  String? get catName => _catName;
  String? get catId => _catId;
  String? get categoryImg => _categoryImg;
  int? get lastPageNumber => _lastPageNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['catName'] = _catName;
    map['catId'] = _catId;
    map['categoryImg'] = _categoryImg;
    map['lastPageNumber'] = _lastPageNumber;
    return map;
  }

}