// class Faqmodel {
//
//   var question ="1.1  I received a defective/damaged item,           can I get a refund?";
//   var answer = "In case the item you received is damaged or defective, you could return the item in the same condition as you received it with the original box and/or packaging intact. Once we receive the returned item, we will inspect it and if the item is found to be defective or damaged, we will process the refund along with any shipping fees incurred.";
//   var isAnswerVisible = false;
// }

class FaqResponseModel {
 late int successCode;
 late String message;
 late String data;

  FaqResponseModel({required this.successCode, required this.message, required this.data});

  FaqResponseModel.fromJson(Map<String, dynamic> json) {
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