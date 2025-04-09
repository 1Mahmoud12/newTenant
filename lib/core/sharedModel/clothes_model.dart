class ClothesModel {
  final String name;
  final String icon;
  int count;
  final num price;

  ClothesModel({
    required this.name,
    required this.icon,
    this.count = 0,
    required this.price,
  });
}
