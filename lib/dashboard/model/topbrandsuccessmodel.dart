class TopBrandSuccessModel {
  TopBrandSuccessModel({
    required this.successCode,
    required this.message,
    required this.data,
  });

  late final int successCode;
  late final String message;
  late final Data data;

  TopBrandSuccessModel.fromJson(Map<String, dynamic> json) {
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
    required this.brands,
  });

  late final List<Brands> brands;

  Data.fromJson(Map<String, dynamic> json) {
    brands = List.from(json['Brands']).map((e) => Brands.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Brands'] = brands.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Brands {
  Brands({
    required this.name,
    required this.brandId,
    required this.brandImage,
  });

  late final String name;
  late final String brandId;
  late final String brandImage;

  Brands.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    brandId = json['brandId'];
    brandImage = json['brandImage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['brandId'] = brandId;
    _data['brandImage'] = brandImage;
    return _data;
  }
}
