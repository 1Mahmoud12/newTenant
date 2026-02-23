import 'dart:convert';

import 'package:rova_star/core/network/local/cache.dart';

class CacheService {
  static Future<void> setJson({required String key, required Map<String, dynamic> value}) async {
    await userCache?.put(key, jsonEncode(value));
  }

  static Future<Map<String, dynamic>?> getJson({required String key}) async {
    final str = userCache?.get(key) as String?;
    if (str == null) return null;
    try {
      final decoded = jsonDecode(str);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  static Future<void> remove({required String key}) async {
    await userCache?.delete(key);
  }
}

class HomeCacheKeys {
  static String get topProducts => homeTopProductsKey;

  static String get bestSeller => homeBestSellerKey;

  static String get newArrivals => homeNewArrivalsKey;
}
