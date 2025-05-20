import 'package:dobzz_seller/core/utils/app_icons.dart';
import 'package:dobzz_seller/feature/home/data/models/categories_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  static String fontFamily = 'Cairo';
  static String appName = 'El-Mamlaka';
  static LatLng locationCache = const LatLng(30.033333, 31.233334);
  static int distance = 100; // Km

  static String notificationChannelKey = 'channel_id1';
  static AddressModel defaultAddress = AddressModel(-1, 'unknown address');
  static String fcmToken = '';
  static String deviceId = '';
  static String subdomain2 = 'shine';
  static String subdomain = 'http://kadin.dobzz.com';
//  static String subdomain = 'kadin';
  static String apiPassword = '123#Social_Codgoo#321';
  static int cartItems = 0;

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static Map jsonServerKey = {};

  static RemoteMessage? messageGlobal;
  static String passwordApi = r'#as@$#$@as#';
  static String currentLanguage = 'en';
  static String unKnownValue = 'Un Known Value'.tr();
  static String token = '';
  static String? mapStyleString;
  static bool noInternet = false;
  static bool tablet = false;
  static String versionApp = '';
  static String packageName = 'com.mah852.dobbz_user';
  static String appleId = '6745216210';
  static String demoAccount = '+966500975853';

  static String urlGoogleMapPlace = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static String urlGoogleMapLocation = 'https://maps.googleapis.com/maps/api/place/details/json';
  static String kGoogleMap = 'AIzaSyAgfXPnIUsG1t0RFfsefqcq7eJdPE1WdA8';
}

enum StatusRequest { completed, pending, canceled }

String unknownValue = 'unknownValue';

bool arabicLanguage = true;

class AddressModel {
  String? name;
  int? addressId;

  AddressModel(this.addressId, this.name);
}

class IconAndText {
  final String icon;
  final String text;

  IconAndText({required this.icon, required this.text});
}

List<DayAndMonth> weekDay = [
  DayAndMonth(day: 'السبت'.tr(), dayInMonth: '30'),
  DayAndMonth(day: 'الاحد'.tr(), dayInMonth: '01'),
  DayAndMonth(day: 'الاثنين'.tr(), dayInMonth: '02'),
  DayAndMonth(day: 'الثلاثاء'.tr(), dayInMonth: '03'),
  DayAndMonth(day: 'الاربعاء'.tr(), dayInMonth: '04'),
  DayAndMonth(day: 'الخميس'.tr(), dayInMonth: '05'),
  DayAndMonth(day: 'الجمعه'.tr(), dayInMonth: '06'),
];

final List<CategoriesModel> categories = [];

class DayAndMonth {
  final String day;
  final String dayInMonth;

  DayAndMonth({required this.day, required this.dayInMonth});
}

class CountryFlag {
  final int id;
  final String name;
  final String code;
  final String image;

  CountryFlag({required this.id, required this.name, required this.code, required this.image});
}

List<CountryFlag> countriesflage = [
  CountryFlag(id: 0, name: 'SA', code: '+966', image: AppIcons.SAIc),
  CountryFlag(id: 1, name: 'EG', code: '+2', image: AppIcons.EGIc),
  CountryFlag(id: 2, name: 'EM', code: '+973', image: AppIcons.AEIc),
];
