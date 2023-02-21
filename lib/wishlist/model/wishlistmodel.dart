class WishlistModel {
  late int successCode;
  late String message;
  late Data data;

  WishlistModel({required this.successCode,required this.message,required this.data});

  WishlistModel.fromJson(Map<String, dynamic> json) {
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

  WishlistModel.fromWishlist();
}

class Data {
  late List<CartData> cartData;

  Data({required this.cartData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Cart Data'] != null) {
      cartData = <CartData>[];
      json['Cart Data'].forEach((v) {
        cartData.add(CartData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cartData != null) {
      data['Cart Data'] = this.cartData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartData {
  late  String name;
  late String productId;
  late String price;
  late String qty;
  late bool isInStock;
  late String image;

  CartData({required this.name,required this.productId,required this.price,required this.qty,required this.image});

  CartData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    productId = json['product_id'];
    price = json['price'];
    qty = json['qty'];
    isInStock = json['is_in_stock'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['product_id'] = this.productId;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['is_in_stock'] = isInStock;
    data['image'] = this.image;
    return data;
  }
}

