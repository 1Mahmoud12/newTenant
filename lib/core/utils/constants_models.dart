import 'package:rova_star/core/services/payment/data/model/payment_method_model.dart';
import 'package:rova_star/feature/Categories/data/models/sub_categories_models.dart';
import 'package:rova_star/feature/account/view/myOrders/data/models/order_model.dart';
import 'package:rova_star/feature/account/view/notificationSetting/data/models/general_notification_setting_model.dart';
import 'package:rova_star/feature/address/data/models/address_model.dart';
import 'package:rova_star/feature/address/data/models/city_model.dart';
import 'package:rova_star/feature/address/data/models/state_model.dart';
import 'package:rova_star/feature/auth/data/models/country_code_model.dart';
import 'package:rova_star/feature/auth/data/models/register_model.dart';
import 'package:rova_star/feature/cart/data/models/cart_item_model.dart';
import 'package:rova_star/feature/checkout/data/models/checkout_details_model.dart';
import 'package:rova_star/feature/favorites/data/model/wish_list_model.dart';
import 'package:rova_star/feature/home/data/models/categories_model.dart';
import 'package:rova_star/feature/home/data/models/product_mdoel.dart';
import 'package:rova_star/feature/home/data/models/sales_model.dart';
import 'package:rova_star/feature/home/data/models/slider_model.dart';
import 'package:rova_star/feature/product/data/model/product_details_model.dart';

class ConstantsModels {
  static CountryCodeModel? countryCodeModel;
  static RegisterModel? registerModel;
  static RegisterModel? requiredValidationModel;
  static ProductModel? topProductModel;
  static ProductModel? bestSellerModel;
  static ProductModel? newArrivalsModel;
  static CartItemModel? cartItemModel;
  static WishListModel? wishListModel;
  static RegisterModel? editProfileModel;
  static CategoriesModel? categoriesModel;
  static ProductDetailsModel? productDetailsModel;
  static AddressModel? addressModel;
  static StateModel? stateModel;
  static CityModel? cityModel;
  static OrderModel? orderModel;
  static CheckoutDetailsModel? checkoutDetailsModel;
  static SubCategoryModel? subCategoryModel;
  static ProductModel? productsModel;
  static ProductModel? searchProductsModel;
  static GeneralNotificationModel? generalNotificationModel;
  static SliderModel? sliderModel;
  static SalesBannerModel? salesBannerModel;

  // Payments
  static PaymentMethodModel? paymentMethodModel;
}
