import 'package:intl/intl.dart';

class OrderDetail {
  OrderDetail({
    this.successCode,
    this.message,
    this.data,});

  OrderDetail.fromJson(dynamic json) {
    successCode = json['SuccessCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? successCode;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SuccessCode'] = successCode;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
    required this.orderName,
    required this.orderId,
    required this.orderPlaced,
    required this.confirmed,
    required this.orderShipped,
    required this.shippingDate,
    required this.outForDelivery,
    required this.expectedDeliveryDate,
    required this.delivered,
    required this.deliveryDate,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.billingAddress,
    required this.products,
    required this.priceDetails,
  });
  late final String? orderName;
  late final String? orderId;
  late final bool orderPlaced;
  late final bool confirmed;
  late final bool orderShipped;
  late final String? shippingDate;
  late final bool outForDelivery;
  late final String? expectedDeliveryDate;
  late final bool delivered;
  late final String? deliveryDate;
  late final String? paymentMethod;
  late final ShippingAddress shippingAddress;
  late final BillingAddress billingAddress;
  late final List<Products> products;
  late final PriceDetails priceDetails;

  Data.fromJson(Map<String, dynamic> json){
    orderName = json['orderId'];
    orderId = json['Orderid'];
    orderPlaced = json['orderPlaced'];
    confirmed = json['comfirmed'];
    orderShipped = json['orderShipped'];
    shippingDate = getLocalDate(json['shippingDate']);
    outForDelivery = json['outForDelivery'];
    expectedDeliveryDate = getLocalDate(json['ExpectedDeliveryDate']);
    delivered = json['Deliveried'];
    deliveryDate = getLocalDate(json['DeliveryDate']);
    paymentMethod = json['paymentMethod'];
    shippingAddress = ShippingAddress.fromJson(json['ShippingAddress']);
    billingAddress = BillingAddress.fromJson(json['BillingAddress']);
    products = List.from(json['products']).map((e)=>Products.fromJson(e)).toList();
    priceDetails = PriceDetails.fromJson(json['priceDetails']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['orderId'] = orderId;
    _data['Orderid'] = orderName;
    _data['orderPlaced'] = orderPlaced;
    _data['comfirmed'] = confirmed;
    _data['orderShipped'] = orderShipped;
    _data['shippingDate'] = shippingDate;
    _data['outForDelivery'] = outForDelivery;
    _data['ExpectedDeliveryDate'] = expectedDeliveryDate;
    _data['Deliveried'] = delivered;
    _data['DeliveryDate'] = deliveryDate;
    _data['paymentMethod'] = paymentMethod;
    _data['ShippingAddress'] = shippingAddress.toJson();
    _data['BillingAddress'] = billingAddress.toJson();
    _data['products'] = products.map((e)=>e.toJson()).toList();
    _data['priceDetails'] = priceDetails.toJson();
    return _data;
  }
}

class ShippingAddress {
  ShippingAddress({
    required this.entityId,
    required this.parentId,
    required this.customerAddressId,
    required this.quoteAddressId,
    required this.regionId,
    required this.region,
    required this.postcode,
    required this.lastname,
    required this.street,
    required this.city,
    required this.email,
    required this.telephone,
    required this.countryId,
    required this.firstname,
    required this.addressType,
  });
  late final String? entityId;
  late final String? parentId;
  late final dynamic customerAddressId;
  late final String? quoteAddressId;
  late final dynamic regionId;
  late final String? region;
  late final String? postcode;
  late final String? lastname;
  late final String? street;
  late final String? city;
  late final String? email;
  late final String? telephone;
  late final String? countryId;
  late final String? firstname;
  late final String? addressType;

  ShippingAddress.fromJson(Map<String, dynamic> json){
    entityId = json['entity_id']?? "";
    parentId = json['parent_id']?? "";
    customerAddressId = json['customer_address_id']?? "";
    quoteAddressId = json['quote_address_id']?? "";
    regionId = json['region_id'] ?? "";
    region = json['region']?? "";
    postcode = json['postcode']?? "";
    lastname = json['lastname']?? "";
    street = json['street']?? "";
    city = json['city']?? "";
    email = json['email']?? "";
    telephone = json['telephone']?? "";
    countryId = json['country_id']?? "";
    firstname = json['firstname']?? "";
    addressType = json['address_type']?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['entity_id'] = entityId;
    _data['parent_id'] = parentId;
    _data['customer_address_id'] = customerAddressId;
    _data['quote_address_id'] = quoteAddressId;
    _data['region_id'] = regionId;
    _data['region'] = region;
    _data['postcode'] = postcode;
    _data['lastname'] = lastname;
    _data['street'] = street;
    _data['city'] = city;
    _data['email'] = email;
    _data['telephone'] = telephone;
    _data['country_id'] = countryId;
    _data['firstname'] = firstname;
    _data['address_type'] = addressType;
    return _data;
  }
}

class PriceDetails {
  PriceDetails({
    this.tax,
    this.codCharge,
    this.shippingCharge,
    this.discount,
    this.total,});

  PriceDetails.fromJson(dynamic json) {
    tax = json['tax'];
    codCharge = json['codCharge'];
    shippingCharge = json['shippingCharge'];
    discount = json['discount'];
    total = json['total'];
  }
  String? tax;
  String? codCharge;
  String? shippingCharge;
  String? discount;
  String? total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tax'] = tax;
    map['codCharge'] = codCharge;
    map['shippingCharge'] = shippingCharge;
    map['discount'] = discount;
    map['total'] = total;
    return map;
  }

}

class Products {
  Products({
    required this.itemId,
    required this.orderId,
    this.parentItemId,
    required this.quoteItemId,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    required this.productId,
    required this.productType,
    required this.productOptions,
    required this.weight,
    required this.isVirtual,
    required this.sku,
    required this.name,
    this.description,
    this.appliedRuleIds,
    this.additionalData,
    required this.isQtyDecimal,
    required this.noDiscount,
    this.qtyBackordered,
    required this.qtyCanceled,
    required this.qtyInvoiced,
    required this.qtyOrdered,
    required this.qtyRefunded,
    required this.qtyShipped,
    this.baseCost,
    required this.price,
    required this.basePrice,
    required this.originalPrice,
    required this.baseOriginalPrice,
    required this.taxPercent,
    required this.taxAmount,
    required this.baseTaxAmount,
    required this.taxInvoiced,
    required this.baseTaxInvoiced,
    required this.discountPercent,
    required this.discountAmount,
    required this.baseDiscountAmount,
    required this.discountInvoiced,
    required this.baseDiscountInvoiced,
    required this.amountRefunded,
    required this.baseAmountRefunded,
    required this.rowTotal,
    required this.baseRowTotal,
    required this.rowInvoiced,
    required this.baseRowInvoiced,
    required this.rowWeight,
    this.baseTaxBeforeDiscount,
    this.taxBeforeDiscount,
    this.extOrderItemId,
    this.lockedDoInvoice,
    this.lockedDoShip,
    required this.priceInclTax,
    required this.basePriceInclTax,
    required this.rowTotalInclTax,
    required this.baseRowTotalInclTax,
    required this.discountTaxCompensationAmount,
    required this.baseDiscountTaxCompensationAmount,
    this.discountTaxCompensationInvoiced,
    this.baseDiscountTaxCompensationInvoiced,
    this.discountTaxCompensationRefunded,
    this.baseDiscountTaxCompensationRefunded,
    this.taxCanceled,
    this.discountTaxCompensationCanceled,
    this.taxRefunded,
    this.baseTaxRefunded,
    this.discountRefunded,
    this.baseDiscountRefunded,
    this.giftMessageId,
    this.giftMessageAvailable,
    required this.freeShipping,
    this.weeeTaxApplied,
    this.weeeTaxAppliedAmount,
    this.weeeTaxAppliedRowAmount,
    this.weeeTaxDisposition,
    this.weeeTaxRowDisposition,
    this.baseWeeeTaxAppliedAmount,
    this.baseWeeeTaxAppliedRowAmnt,
    this.baseWeeeTaxDisposition,
    this.baseWeeeTaxRowDisposition,
  });
  late final String? itemId;
  late final String? orderId;
  late final dynamic parentItemId;
  late final String? quoteItemId;
  late final String? storeId;
  late final String? createdAt;
  late final String? updatedAt;
  late final String? productId;
  late final String? productType;
  late final ProductOptions productOptions;
  late final String? weight;
  late final String? isVirtual;
  late final String? sku;
  late final String name;
  late final dynamic description;
  late final dynamic appliedRuleIds;
  late final dynamic additionalData;
  late final String? isQtyDecimal;
  late final String? noDiscount;
  late final dynamic qtyBackordered;
  late final String? qtyCanceled;
  late final String? qtyInvoiced;
  late final String qtyOrdered;
  late final String? qtyRefunded;
  late final String? qtyShipped;
  late final dynamic baseCost;
  late final String? price;
  late final String? basePrice;
  late final String? originalPrice;
  late final String? baseOriginalPrice;
  late final String? taxPercent;
  late final String? taxAmount;
  late final String? baseTaxAmount;
  late final String? taxInvoiced;
  late final String? baseTaxInvoiced;
  late final String? discountPercent;
  late final String? discountAmount;
  late final String? baseDiscountAmount;
  late final String? discountInvoiced;
  late final String? baseDiscountInvoiced;
  late final String? amountRefunded;
  late final String? baseAmountRefunded;
  late final String? rowTotal;
  late final String? baseRowTotal;
  late final String? rowInvoiced;
  late final String? baseRowInvoiced;
  late final String? rowWeight;
  late final dynamic baseTaxBeforeDiscount;
  late final dynamic taxBeforeDiscount;
  late final dynamic extOrderItemId;
  late final dynamic lockedDoInvoice;
  late final dynamic lockedDoShip;
  late final String? priceInclTax;
  late final String? basePriceInclTax;
  late final String? rowTotalInclTax;
  late final String? baseRowTotalInclTax;
  late final String? discountTaxCompensationAmount;
  late final String? baseDiscountTaxCompensationAmount;
  late final dynamic discountTaxCompensationInvoiced;
  late final dynamic baseDiscountTaxCompensationInvoiced;
  late final dynamic discountTaxCompensationRefunded;
  late final dynamic baseDiscountTaxCompensationRefunded;
  late final dynamic taxCanceled;
  late final dynamic discountTaxCompensationCanceled;
  late final dynamic taxRefunded;
  late final dynamic baseTaxRefunded;
  late final dynamic discountRefunded;
  late final dynamic baseDiscountRefunded;
  late final dynamic giftMessageId;
  late final dynamic giftMessageAvailable;
  late final String? freeShipping;
  late final dynamic weeeTaxApplied;
  late final dynamic weeeTaxAppliedAmount;
  late final dynamic weeeTaxAppliedRowAmount;
  late final dynamic weeeTaxDisposition;
  late final dynamic weeeTaxRowDisposition;
  late final dynamic baseWeeeTaxAppliedAmount;
  late final dynamic baseWeeeTaxAppliedRowAmnt;
  late final dynamic baseWeeeTaxDisposition;
  late final dynamic baseWeeeTaxRowDisposition;

  Products.fromJson(Map<String, dynamic> json){
    itemId = json['item_id'];
    orderId = json['order_id'];
    parentItemId = null;
    quoteItemId = json['quote_item_id']??"";
    storeId = json['store_id']??"";
    createdAt = json['created_at']?? "";
    updatedAt = json['updated_at']?? "";
    productId = json['product_id']?? "";
    productType = json['product_type']?? "";
    productOptions = ProductOptions.fromJson(json['product_options']);
    weight = json['weight']??"";
    isVirtual = json['is_virtual']?? "";
    sku = json['sku']?? "";
    name = json['name']?? "";
    description = null;
    appliedRuleIds = null;
    additionalData = null;
    isQtyDecimal = json['is_qty_decimal']?? "";
    noDiscount = json['no_discount']?? "";
    qtyBackordered = null;
    qtyCanceled = json['qty_canceled']?? "";
    qtyInvoiced = json['qty_invoiced']?? "";
    qtyOrdered = json['qty_ordered']?? "";
    qtyRefunded = json['qty_refunded']?? "";
    qtyShipped = json['qty_shipped'] ?? "";
    baseCost = null;
    price = json['price']?? "";
    basePrice = json['base_price']?? "";
    originalPrice = json['original_price']?? "";
    baseOriginalPrice = json['base_original_price']?? "";
    taxPercent = json['tax_percent']?? "";
    taxAmount = json['tax_amount']?? "";
    baseTaxAmount = json['base_tax_amount']?? "";
    taxInvoiced = json['tax_invoiced']?? "";
    baseTaxInvoiced = json['base_tax_invoiced']?? "";
    discountPercent = json['discount_percent']?? "";
    discountAmount = json['discount_amount']?? "";
    baseDiscountAmount = json['base_discount_amount']?? "";
    discountInvoiced = json['discount_invoiced']?? "";
    baseDiscountInvoiced = json['base_discount_invoiced']?? "";
    amountRefunded = json['amount_refunded']?? "";
    baseAmountRefunded = json['base_amount_refunded']?? "";
    rowTotal = json['row_total']?? "";
    baseRowTotal = json['base_row_total']?? "";
    rowInvoiced = json['row_invoiced']?? "";
    baseRowInvoiced = json['base_row_invoiced']?? "";
    rowWeight = json['row_weight']?? "";
    baseTaxBeforeDiscount = null;
    taxBeforeDiscount = null;
    extOrderItemId = null;
    lockedDoInvoice = null;
    lockedDoShip = null;
    priceInclTax = json['price_incl_tax']?? "";
    basePriceInclTax = json['base_price_incl_tax']?? "";
    rowTotalInclTax = json['row_total_incl_tax']?? "";
    baseRowTotalInclTax = json['base_row_total_incl_tax']?? "";
    discountTaxCompensationAmount = json['discount_tax_compensation_amount']?? "";
    baseDiscountTaxCompensationAmount = json['base_discount_tax_compensation_amount']?? "";
    discountTaxCompensationInvoiced = null;
    baseDiscountTaxCompensationInvoiced = null;
    discountTaxCompensationRefunded = null;
    baseDiscountTaxCompensationRefunded = null;
    taxCanceled = null;
    discountTaxCompensationCanceled = null;
    taxRefunded = null;
    baseTaxRefunded = null;
    discountRefunded = null;
    baseDiscountRefunded = null;
    giftMessageId = null;
    giftMessageAvailable = null;
    freeShipping = json['free_shipping']?? "";
    weeeTaxApplied = null;
    weeeTaxAppliedAmount = null;
    weeeTaxAppliedRowAmount = null;
    weeeTaxDisposition = null;
    weeeTaxRowDisposition = null;
    baseWeeeTaxAppliedAmount = null;
    baseWeeeTaxAppliedRowAmnt = null;
    baseWeeeTaxDisposition = null;
    baseWeeeTaxRowDisposition = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['item_id'] = itemId;
    _data['order_id'] = orderId;
    _data['parent_item_id'] = parentItemId;
    _data['quote_item_id'] = quoteItemId;
    _data['store_id'] = storeId;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['product_id'] = productId;
    _data['product_type'] = productType;
    _data['product_options'] = productOptions.toJson();
    _data['weight'] = weight;
    _data['is_virtual'] = isVirtual;
    _data['sku'] = sku;
    _data['name'] = name;
    _data['description'] = description;
    _data['applied_rule_ids'] = appliedRuleIds;
    _data['additional_data'] = additionalData;
    _data['is_qty_decimal'] = isQtyDecimal;
    _data['no_discount'] = noDiscount;
    _data['qty_backordered'] = qtyBackordered;
    _data['qty_canceled'] = qtyCanceled;
    _data['qty_invoiced'] = qtyInvoiced;
    _data['qty_ordered'] = qtyOrdered;
    _data['qty_refunded'] = qtyRefunded;
    _data['qty_shipped'] = qtyShipped;
    _data['base_cost'] = baseCost;
    _data['price'] = price;
    _data['base_price'] = basePrice;
    _data['original_price'] = originalPrice;
    _data['base_original_price'] = baseOriginalPrice;
    _data['tax_percent'] = taxPercent;
    _data['tax_amount'] = taxAmount;
    _data['base_tax_amount'] = baseTaxAmount;
    _data['tax_invoiced'] = taxInvoiced;
    _data['base_tax_invoiced'] = baseTaxInvoiced;
    _data['discount_percent'] = discountPercent;
    _data['discount_amount'] = discountAmount;
    _data['base_discount_amount'] = baseDiscountAmount;
    _data['discount_invoiced'] = discountInvoiced;
    _data['base_discount_invoiced'] = baseDiscountInvoiced;
    _data['amount_refunded'] = amountRefunded;
    _data['base_amount_refunded'] = baseAmountRefunded;
    _data['row_total'] = rowTotal;
    _data['base_row_total'] = baseRowTotal;
    _data['row_invoiced'] = rowInvoiced;
    _data['base_row_invoiced'] = baseRowInvoiced;
    _data['row_weight'] = rowWeight;
    _data['base_tax_before_discount'] = baseTaxBeforeDiscount;
    _data['tax_before_discount'] = taxBeforeDiscount;
    _data['ext_order_item_id'] = extOrderItemId;
    _data['locked_do_invoice'] = lockedDoInvoice;
    _data['locked_do_ship'] = lockedDoShip;
    _data['price_incl_tax'] = priceInclTax;
    _data['base_price_incl_tax'] = basePriceInclTax;
    _data['row_total_incl_tax'] = rowTotalInclTax;
    _data['base_row_total_incl_tax'] = baseRowTotalInclTax;
    _data['discount_tax_compensation_amount'] = discountTaxCompensationAmount;
    _data['base_discount_tax_compensation_amount'] = baseDiscountTaxCompensationAmount;
    _data['discount_tax_compensation_invoiced'] = discountTaxCompensationInvoiced;
    _data['base_discount_tax_compensation_invoiced'] = baseDiscountTaxCompensationInvoiced;
    _data['discount_tax_compensation_refunded'] = discountTaxCompensationRefunded;
    _data['base_discount_tax_compensation_refunded'] = baseDiscountTaxCompensationRefunded;
    _data['tax_canceled'] = taxCanceled;
    _data['discount_tax_compensation_canceled'] = discountTaxCompensationCanceled;
    _data['tax_refunded'] = taxRefunded;
    _data['base_tax_refunded'] = baseTaxRefunded;
    _data['discount_refunded'] = discountRefunded;
    _data['base_discount_refunded'] = baseDiscountRefunded;
    _data['gift_message_id'] = giftMessageId;
    _data['gift_message_available'] = giftMessageAvailable;
    _data['free_shipping'] = freeShipping;
    _data['weee_tax_applied'] = weeeTaxApplied;
    _data['weee_tax_applied_amount'] = weeeTaxAppliedAmount;
    _data['weee_tax_applied_row_amount'] = weeeTaxAppliedRowAmount;
    _data['weee_tax_disposition'] = weeeTaxDisposition;
    _data['weee_tax_row_disposition'] = weeeTaxRowDisposition;
    _data['base_weee_tax_applied_amount'] = baseWeeeTaxAppliedAmount;
    _data['base_weee_tax_applied_row_amnt'] = baseWeeeTaxAppliedRowAmnt;
    _data['base_weee_tax_disposition'] = baseWeeeTaxDisposition;
    _data['base_weee_tax_row_disposition'] = baseWeeeTaxRowDisposition;
    return _data;
  }
}

class ProductOptions {
  ProductOptions({
    required this.infoBuyRequest,
  });
  late final InfoBuyRequest infoBuyRequest;

  ProductOptions.fromJson(Map<String, dynamic> json){
    infoBuyRequest = InfoBuyRequest.fromJson(json['info_buyRequest']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['info_buyRequest'] = infoBuyRequest.toJson();
    return _data;
  }
}

class InfoBuyRequest {
  InfoBuyRequest({
    required this.product,
    required this.uenc,
    required this.qty,
  });
  late final String? product;
  late final String? uenc;
  late final dynamic qty;

  InfoBuyRequest.fromJson(Map<String, dynamic> json){
    product = json['product']?? "";
    uenc = json['uenc']?? "";
    qty = json['qty']?? "";
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['qty'] = qty;
    return map;
  }

}

class BillingAddress {
  BillingAddress({
    this.entityId,
    this.parentId,
    this.customerAddressId,
    this.quoteAddressId,
    this.regionId,
    this.customerId,
    this.fax,
    this.region,
    this.postcode,
    this.lastname,
    this.street,
    this.city,
    this.email,
    this.telephone,
    this.countryId,
    this.firstname,
    this.addressType,
    this.prefix,
    this.middlename,
    this.suffix,
    this.company,
    this.vatId,
    this.vatIsValid,
    this.vatRequestId,
    this.vatRequestDate,
    this.vatRequestSuccess,
    this.mspCodAmount,
    this.baseMspCodAmount,
    this.mspCodTaxAmount,
    this.baseMspCodTaxAmount,});

  BillingAddress.fromJson(dynamic json) {
    entityId = json['entity_id'];
    parentId = json['parent_id'];
    customerAddressId = json['customer_address_id'];
    quoteAddressId = json['quote_address_id'];
    regionId = json['region_id'];
    customerId = json['customer_id'];
    fax = json['fax'];
    region = json['region'];
    postcode = json['postcode'];
    lastname = json['lastname'];
    street = json['street'];
    city = json['city'];
    email = json['email'];
    telephone = json['telephone'];
    countryId = json['country_id'];
    firstname = json['firstname'];
    addressType = json['address_type'];
    prefix = json['prefix'];
    middlename = json['middlename'];
    suffix = json['suffix'];
    company = json['company'];
    vatId = json['vat_id'];
    vatIsValid = json['vat_is_valid'];
    vatRequestId = json['vat_request_id'];
    vatRequestDate = json['vat_request_date'];
    vatRequestSuccess = json['vat_request_success'];
    mspCodAmount = json['msp_cod_amount'];
    baseMspCodAmount = json['base_msp_cod_amount'];
    mspCodTaxAmount = json['msp_cod_tax_amount'];
    baseMspCodTaxAmount = json['base_msp_cod_tax_amount'];
  }
  String? entityId;
  String? parentId;
  dynamic customerAddressId;
  String? quoteAddressId;
  dynamic regionId;
  dynamic customerId;
  dynamic fax;
  String? region;
  String? postcode;
  String? lastname;
  String? street;
  String? city;
  String? email;
  String? telephone;
  String? countryId;
  String? firstname;
  String? addressType;
  dynamic prefix;
  dynamic middlename;
  dynamic suffix;
  dynamic company;
  dynamic vatId;
  dynamic vatIsValid;
  dynamic vatRequestId;
  dynamic vatRequestDate;
  dynamic vatRequestSuccess;
  dynamic mspCodAmount;
  dynamic baseMspCodAmount;
  dynamic mspCodTaxAmount;
  dynamic baseMspCodTaxAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['entity_id'] = entityId;
    map['parent_id'] = parentId;
    map['customer_address_id'] = customerAddressId;
    map['quote_address_id'] = quoteAddressId;
    map['region_id'] = regionId;
    map['customer_id'] = customerId;
    map['fax'] = fax;
    map['region'] = region;
    map['postcode'] = postcode;
    map['lastname'] = lastname;
    map['street'] = street;
    map['city'] = city;
    map['email'] = email;
    map['telephone'] = telephone;
    map['country_id'] = countryId;
    map['firstname'] = firstname;
    map['address_type'] = addressType;
    map['prefix'] = prefix;
    map['middlename'] = middlename;
    map['suffix'] = suffix;
    map['company'] = company;
    map['vat_id'] = vatId;
    map['vat_is_valid'] = vatIsValid;
    map['vat_request_id'] = vatRequestId;
    map['vat_request_date'] = vatRequestDate;
    map['vat_request_success'] = vatRequestSuccess;
    map['msp_cod_amount'] = mspCodAmount;
    map['base_msp_cod_amount'] = baseMspCodAmount;
    map['msp_cod_tax_amount'] = mspCodTaxAmount;
    map['base_msp_cod_tax_amount'] = baseMspCodTaxAmount;
    return map;
  }
}

getLocalDate(String date) {
  var dateFormat = DateFormat("dd-MM-yyyy hh:mm aa");
  var utcDate = dateFormat.format(DateTime.parse(date));
  var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
  return dateFormat.format(DateTime.parse(localDate));
}