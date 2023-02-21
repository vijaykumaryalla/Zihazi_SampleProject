class PaymentMethodObj {
  PaymentMethodObj({
    required this.methodId,
    required this.methodName,
    required this.methodCode,
    required this.imgUrl,
    required this.isChecked,
    required this.paymentText,
  });
  int methodId;
  String methodName;
  String methodCode;
  String imgUrl;
  bool isChecked;
  String paymentText;

}