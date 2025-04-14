import 'package:dobzz_seller/core/sharedModel/clothes_model.dart';

class CategoriesModel {
  final int idServices;
  final String nameImage;
  final String nameServices;
  bool selected;
  final List<ClothesModel> clothes = [];

  CategoriesModel({required this.idServices, required this.nameImage, required this.nameServices, this.selected = false}) {
    selected = false;
  }
}
