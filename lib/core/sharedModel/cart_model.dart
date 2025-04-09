class CartModel {
  String id;
  int idSize;
  int servicePriceId;
  int myCountInMap;
  String name;
  String nameCategory;
  String size;
  String price;

  bool selected;

  CartModel({
    required this.id,
    required this.myCountInMap,
    required this.servicePriceId,
    required this.idSize,
    required this.name,
    required this.nameCategory,
    required this.size,
    required this.price,
    this.selected = false,
  }) {
    selected = false;
  }
}
