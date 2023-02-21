class Country {
  Country({
    required this.successCode,
    required this.message,
    required this.data,
  });
  late final int successCode;
  late final String message;
  late final List<CountryCode> data;

  Country.fromJson(Map<String, dynamic> json){
    successCode = json['SuccessCode'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>CountryCode.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['SuccessCode'] = successCode;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class CountryCode {
  CountryCode({
    required this.value,
    required this.label,
    required this.isRegionRequired,
    required this.states,
  });
  late final String value;
  late final String label;
  late final dynamic isRegionRequired;
  late final dynamic states;

  CountryCode.fromJson(Map<String, dynamic> json){
    value = json['value'];
    label = json['label'];
    isRegionRequired = (json['is_region_required'] != null)? json['is_region_required']: "";
    states = (json['states'] != null)? List.from(json['states']).map((e)=>States.fromJson(e)).toList(): "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['value'] = value;
    _data['label'] = label;
    _data['is_region_required'] = isRegionRequired;
    _data['states'] = (_data['states'] != null)? states.map((e)=>e.toJson()).toList(): "";
    return _data;
  }
}

class States {
  States({
    required this.title,
    required this.value,
    required this.label,
  });
  late final String title;
  late final String value;
  late final String label;

  States.fromJson(Map<String, dynamic> json){
    title = json['title'];
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['value'] = value;
    _data['label'] = label;
    return _data;
  }
}