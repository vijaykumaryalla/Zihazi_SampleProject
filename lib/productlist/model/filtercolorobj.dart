class FilterObj {
  FilterObj({
    required this.filterColorObj,
    required this.filterpriceObj,
    required this.isSelectedId,
    required this.filterName,
  });
  List<FilterColorObj> filterColorObj;
  FilterPriceObj filterpriceObj;
  int isSelectedId; //1 for color, 2 for price
  String filterName;


}

class FilterColorObj {
  FilterColorObj({
    required this.colorId,
    required this.colorName,
    required this.isChecked,
  });
  String colorId;
  String colorName;
  bool isChecked;

}

class FilterPriceObj {
  FilterPriceObj({
    required this.startPrice,
    required this.endPrice,
  });
  String startPrice;
  String endPrice;

}