class Product {
  Product({
    this.topCategories,});

  Product.fromJson(dynamic json) {
    if (json['topCategories'] != null) {
      topCategories = [];
      json['topCategories'].forEach((v) {
        topCategories?.add(TopCategories.fromJson(v));
      });
    }
  }
  List<TopCategories>? topCategories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (topCategories != null) {
      map['topCategories'] = topCategories?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class TopCategories {
  TopCategories({
    this.catName,
    this.catId,
    this.bannerImg,
    this.viewId,
    this.products,});

  TopCategories.fromJson(dynamic json) {
    catName = json['catName'];
    catId = json['catId'];
    bannerImg = json['bannerImg'];
    viewId = json['viewId'];
    if (json['Products'] != null) {
      products = [];
      json['Products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
  }
  String? catName;
  int? catId;
  String? bannerImg;
  int? viewId;
  List<Products>? products;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['catName'] = catName;
    map['catId'] = catId;
    map['bannerImg'] = bannerImg;
    map['viewId'] = viewId;
    if (products != null) {
      map['Products'] = products?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Products {
  Products({
    this.prodId,
    this.prodName,
    this.prodAmount,
    this.prodImage,
    this.isFavorite,});

  Products.fromJson(dynamic json) {
    prodId = json['prodId'];
    prodName = json['prodName'];
    prodAmount = json['prodAmount'];
    prodImage = json['prodImage'];
    isFavorite = json['isFavorite'];
  }
  int? prodId;
  String? prodName;
  String? prodAmount;
  String? prodImage;
  bool? isFavorite;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['prodId'] = prodId;
    map['prodName'] = prodName;
    map['prodAmount'] = prodAmount;
    map['prodImage'] = prodImage;
    map['isFavorite'] = isFavorite;
    return map;
  }

}