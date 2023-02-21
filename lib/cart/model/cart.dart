class Cart {
  Cart({
    required this.successCode,
    required this.message,
    required this.data,
    required this.shippingMethods,
    required this.tax,
    required this.cODPrice,
    required this.discountAmount,
  });
  late final int successCode;
  late final String message;
  late final Data data;
  late final List<ShippingMethods> shippingMethods;
  late final dynamic tax;
  late final dynamic cODPrice;
  late final dynamic discountAmount;

  Cart.fromJson(Map<String, dynamic> json){
    successCode = json['SuccessCode'];
    message = json['message'];
    data = Data.fromJson(json['data']);
    shippingMethods = List.from(json['shipping-methods']).map((e)=>ShippingMethods.fromJson(e)).toList();
    tax = json['tax'];
    cODPrice = json['COD_price'];
    discountAmount = json['discount_amount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['SuccessCode'] = successCode;
    _data['message'] = message;
    _data['data'] = data.toJson();
    _data['shipping-methods'] = shippingMethods.map((e)=>e.toJson()).toList();
    _data['tax'] = tax;
    _data['COD_price'] = cODPrice;
    _data['discount_amount'] = discountAmount;
    return _data;
  }
}

class Data {
  Data({
    required this.cartData,
  });
  late final List<CartData> cartData;

  Data.fromJson(Map<String, dynamic> json){
    cartData = List.from(json['Cart Data']).map((e)=>CartData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Cart Data'] = cartData.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class CartData {
  CartData({
    required this.name,
    required this.productId,
    required this.price,
    required this.qty,
    required this.subtotal,
    required this.image,
  });
  late final String name;
  late final String productId;
  late final dynamic price;
  late final int qty;
  late final dynamic subtotal;
  late final String image;

  CartData.fromJson(Map<String, dynamic> json){
    name = json['name'];
    productId = json['product_id'];
    price = json['price'];
    qty = json['qty'];
    subtotal = json['subtotal'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['product_id'] = productId;
    _data['price'] = price;
    _data['qty'] = qty;
    _data['subtotal'] = subtotal;
    _data['image'] = image;
    return _data;
  }
}

class ShippingMethods {
  ShippingMethods({
    required this.carrierCode,
    required this.carrierTitle,
    required this.amount,
    required this.baseAmount,
    required this.available,
    required this.errorMessage,
    required this.priceExclTax,
    required this.priceInclTax,
  });
  late final String carrierCode;
  late final String carrierTitle;
  late final dynamic amount;
  late final dynamic baseAmount;
  late final bool available;
  late final String errorMessage;
  late final dynamic priceExclTax;
  late final dynamic priceInclTax;

  ShippingMethods.fromJson(Map<String, dynamic> json){
    carrierCode = json['carrier_code'];
    carrierTitle = json['carrier_title'];
    amount = json['amount']?? "0";
    baseAmount = json['base_amount'];
    available = json['available'];
    errorMessage = json['error_message']?? "";
    priceExclTax = json['price_excl_tax'];
    priceInclTax = json['price_incl_tax'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['carrier_code'] = carrierCode;
    _data['carrier_title'] = carrierTitle;
    _data['amount'] = amount;
    _data['base_amount'] = baseAmount;
    _data['available'] = available;
    _data['error_message'] = errorMessage;
    _data['price_excl_tax'] = priceExclTax;
    _data['price_incl_tax'] = priceInclTax;
    return _data;
  }
}