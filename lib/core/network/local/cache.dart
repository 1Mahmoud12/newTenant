import 'package:dobzz_seller/feature/auth/data/models/register_model.dart';
import 'package:hive_flutter/adapters.dart';

Box? userCache;
Box? loginCache;
String loginCacheBoxKey = 'loginCache';

String userCacheBoxKey = 'userCache';
// keys

String languageAppKey = 'languageAppKey';
String rememberMeKey = 'rememberMeKey';
String onBoardingKey = 'onBoardingKey';
String loginCacheKey = 'userCacheKey';
String darkModeKey = 'darkModeKey';
String idUserKey = 'idUserKey';
String locationCacheKey = 'locationCacheKey';
String allMyAddressesKey = 'allMyAddressesKey';
String advertiseModelKey = 'advertiseModelKey';
String categoriesModelKey = 'categoriesModelKey';
String homeTopProductsKey = 'homeTopProductsKey';
String homeBestSellerKey = 'homeBestSellerKey';
String homeNewArrivalsKey = 'homeNewArrivalsKey';
int idUserValue = 0;
String fcmTokenKey = 'fcmTokenKey';
String deviceIdKey = 'deviceIdKey';

// value
bool onBoardingValue = true;
bool rememberMe = false;

bool darkModeValue = false;

RegisterModel? loginCacheValue;
// AllMyAddresses allMyAddressesCache = AllMyAddresses();
// AdvertiseModel advertiseModelCache = AdvertiseModel();
// CategoriesModel? categoriesModelCache;
String? locationCacheValue;

// biometrics
String biometricEnabledKey = 'biometricEnabledKey';
String biometricTypeKey = 'biometricTypeKey';
String biometricUserCacheKey = 'biometricUserCacheKey';
String biometricAuthKey = 'biometricAuthKey';
// login credentials
String loginEmailKey = 'loginEmailKey';
String alternativeLoginEmailKey = 'alternativeLoginEmailKey';
String loginPasswordKey = 'loginPasswordKey';
String alternativeLoginPasswordKey = 'alternativeLoginPasswordKey';
