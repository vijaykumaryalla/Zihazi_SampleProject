class AddWishListToCart{


  late int successCode;
  late String message;
  late List<Data> data;

  AddWishListToCart({required this.successCode,required this.message,required this.data});

  AddWishListToCart.fromJson(Map<String, dynamic> json) {
    successCode = json['SuccessCode'];
    message = json['message'];
    if (json['data'] != null) {
      data =  <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SuccessCode'] = this.successCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  late int itemId;
  late String sku;
  late int qty;
  late String name;
  late int price;
  late String productType;
  late String quoteId;

  Data(
      {required this.itemId,
        required this.sku,
        required this.qty,
        required this.name,
        required this.price,
        required this.productType,
        required this.quoteId});

  Data.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    sku = json['sku'];
    qty = json['qty'];
    name = json['name'];
    price = json['price'];
    productType = json['product_type'];
    quoteId = json['quote_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['sku'] = this.sku;
    data['qty'] = this.qty;
    data['name'] = this.name;
    data['price'] = this.price;
    data['product_type'] = this.productType;
    data['quote_id'] = this.quoteId;
    return data;
  }



}