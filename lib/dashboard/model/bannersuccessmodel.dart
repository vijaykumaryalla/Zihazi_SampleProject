class BannerSuccessModel {
  BannerSuccessModel({
    required this.successCode,
    required this.message,
    required this.data,
  });
  late final int successCode;
  late final String message;
  late final Data data;

  BannerSuccessModel.fromJson(Map<String, dynamic> json){
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
    required this.bannerList,
  });
  late final List<BannerList> bannerList;

  Data.fromJson(Map<String, dynamic> json){
    bannerList = List.from(json['bannerList']).map((e)=>BannerList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['bannerList'] = bannerList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class BannerList {
  BannerList({
    required this.bannerId,
    required this.bannerImg,
  });
  late final String bannerId;
  late final String bannerImg;

  BannerList.fromJson(Map<String, dynamic> json){
    bannerId = json['bannerId'];
    bannerImg = json['bannerImg'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['bannerId'] = bannerId;
    _data['bannerImg'] = bannerImg;
    return _data;
  }
}