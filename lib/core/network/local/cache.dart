import 'package:hive_flutter/adapters.dart';
import 'package:dobzz_seller/feature/auth/data/models/register_model.dart';

Box? userCache;
String userCacheBoxKey = 'userCache';
// keys

String languageAppKey = 'languageAppKey';
String rememberMeKey = 'rememberMeKey';
String onBoardingKey = 'onBoardingKey';
String userCacheKey = 'userCacheKey';
String darkModeKey = 'darkModeKey';
String idUserKey = 'idUserKey';
String locationCacheKey = 'locationCacheKey';
String allMyAddressesKey = 'allMyAddressesKey';
String advertiseModelKey = 'advertiseModelKey';
String categoriesModelKey = 'categoriesModelKey';
int idUserValue = 0;
String fcmTokenKey = 'fcmTokenKey';
String deviceIdKey = 'deviceIdKey';

// value
bool onBoardingValue = true;
bool rememberMe = false;

bool darkModeValue = false;

RegisterModel? userCacheValue ;
// AllMyAddresses allMyAddressesCache = AllMyAddresses();
// AdvertiseModel advertiseModelCache = AdvertiseModel();
// CategoriesModel? categoriesModelCache;
String? locationCacheValue;
