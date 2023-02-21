class CategorySearchReqModel {
  CategorySearchReqModel({
    required this.token,
    required this.categoryName,
    required this.pageNo,
    required this.pageSize,
    required this.key,
    required this.value,
    required this.skey,
    required this.sorder,
  });
  late final String token;
  late final String categoryName;
  late final int pageNo;
  late final int pageSize;
  late final String key;
  late final String value;
  late final String skey;
  late final String sorder;

  CategorySearchReqModel.fromJson(Map<String, dynamic> json){
    token = json['token'];
    categoryName = json['name'];
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    key = json['key'];
    value = json['value'];
    skey = json['skey'];
    sorder = json['sorder'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token;
    _data['name'] = categoryName;
    _data['pageNo'] = pageNo;
    _data['pageSize'] = pageSize;
    _data['key'] = key;
    _data['value'] = value;
    _data['skey'] = skey;
    _data['sorder'] = sorder;
    return _data;
  }
}