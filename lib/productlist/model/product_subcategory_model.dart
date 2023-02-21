class ProductFromSubCategoryReqModel {
  ProductFromSubCategoryReqModel({
    required this.token,
    required this.categoryId,
    required this.subcategoryId,
    required this.pageNo,
    required this.pageSize,
    required this.key,
    required this.value,
    required this.sorder,
    required this.skey,
  });
  late final String token;
  late final int categoryId;
  late final int subcategoryId;
  late final int pageNo;
  late final int pageSize;
  late final String key;
  late final String value;
  late final String sorder;
  late final String skey;

  ProductFromSubCategoryReqModel.fromJson(Map<String, dynamic> json){
    token = json['token'];
    categoryId = json['categoryId'];
    subcategoryId = json['subcategoryId'];
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    key = json['key'];
    value = json['value'];
    sorder = json['sorder'];
    skey = json['skey'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token;
    _data['categoryId'] = categoryId;
    _data['subcategoryId'] = subcategoryId;
    _data['pageNo'] = pageNo;
    _data['pageSize'] = pageSize;
    _data['key'] = key;
    _data['value'] = value;
    _data['sorder'] = sorder;
    _data['skey'] = skey;
    return _data;
  }
}