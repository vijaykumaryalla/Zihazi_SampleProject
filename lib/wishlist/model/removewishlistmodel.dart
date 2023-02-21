class RemoveWishlistRes {
  late int successCode;
  late String message;
  late String data;

  RemoveWishlistRes({required this.successCode, required this.message, required this.data});

  RemoveWishlistRes.fromJson(Map<String, dynamic> json) {
    successCode = json['SuccessCode'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SuccessCode'] = this.successCode;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}