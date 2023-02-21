import 'package:flutter/foundation.dart';

class ProductDetailModel {
  late int successCode;
  late String message;
  late Data data;

  ProductDetailModel({required this.successCode, required this.message, required this.data});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    successCode = json['SuccessCode'];
    message = json['message'];
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SuccessCode'] = this.successCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  Data({
    required this.productId,
    required this.isFavorate,
    required this.title,
    required this.rating,
    required this.price,
    required this.prodAmount,
    required this.topDesc,
    required this.productImageUrl,
    required this.bottomDesc,
    required this.moreInfo,
    required this.reviewsList,
  });
  late final String productId;
  late final bool isFavorate;
  late final String title;
  late final String rating;
  late final String price;
  late final String prodAmount;
  late final String topDesc;
  late final List<ProductImageUrl> productImageUrl;
  late final List<String> bottomDesc;
  late final List<MoreInfo> moreInfo;
  late List<ReviewsList> reviewsList;

  Data.fromJson(Map<String, dynamic> json){
    productId = json['productId'];
    isFavorate = json['isFavorate'];
    title = json['title'];
    rating = json['rating'] ?? "0";
    price = json['price'];
    prodAmount = json['prodAmount'] ?? json['price'];
    topDesc = json['topDesc'];
    productImageUrl = List.from(json['productImageUrl']).map((e)=>ProductImageUrl.fromJson(e)).toList();
    bottomDesc = List.castFrom<dynamic, String>(json['bottomDesc']);
    moreInfo = List.from(json['moreInfo']).map((e)=>MoreInfo.fromJson(e)).toList();
    if (json['reviewsList'] != null) {
      reviewsList = <ReviewsList>[];
      json['reviewsList'].forEach((v) {
        reviewsList.add( ReviewsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['productId'] = productId;
    _data['isFavorate'] = isFavorate;
    _data['title'] = title;
    _data['rating'] = rating;
    _data['price'] = price;
    _data['prodAmount'] = prodAmount;
    _data['topDesc'] = topDesc;
    _data['productImageUrl'] = productImageUrl.map((e)=>e.toJson()).toList();
    _data['bottomDesc'] = bottomDesc;
    _data['moreInfo'] = moreInfo.map((e)=>e.toJson()).toList();
    _data['reviewsList'] = reviewsList;
    return _data;
  }
}

class ProductImageUrl {
  ProductImageUrl({
    required this.url,
  });
  late final String url;

  ProductImageUrl.fromJson(Map<String, dynamic> json){
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['url'] = url;
    return _data;
  }
}

class MoreInfo {
  MoreInfo({
    required this.label,
    required this.value,
  });
  late final String label;
  late final String value;

  MoreInfo.fromJson(Map<String, dynamic> json){
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['label'] = label;
    _data['value'] = value;
    return _data;
  }
}

class ReviewsList {
  late String title;
  late String description;
  late String rating;
  late String customerName;
  late String date;

  ReviewsList({required this.title, required this.description,required this.rating, required this.customerName, required this.date});

  ReviewsList.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    rating = json["rating"]?? "0";
    customerName = json['customerName'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data["rating"] = this.rating;
    data['customerName'] = this.customerName;
    data['date'] = this.date;
    return data;
  }
}