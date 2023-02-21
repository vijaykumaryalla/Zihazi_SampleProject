class CategorySuccessModel {
  CategorySuccessModel({
    required this.SuccessCode,
    required this.message,
    required this.data,
  });
  late final int SuccessCode;
  late final String message;
  late final Data data;

  CategorySuccessModel.fromJson(Map<String, dynamic> json){
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
    required this.categories,
  });
  late final List<Categories> categories;

  Data.fromJson(Map<String, dynamic> json){
    categories = List.from(json['categories']).map((e)=>Categories.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categories'] = categories.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Categories {
  Categories({
    required this.categoryName,
    required this.categoryId,
    required this.categoryimage,
  });
  late final String categoryName;
  late final String categoryId;
  late final String categoryimage;

  Categories.fromJson(Map<String, dynamic> json){
    categoryName = json['categoryName'];
    categoryId = json['categoryId'];
    categoryimage = json['categoryimage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categoryName'] = categoryName;
    _data['categoryId'] = categoryId;
    _data['categoryimage'] = categoryimage;
    return _data;
  }
}

