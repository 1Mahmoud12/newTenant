import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:rova_star/core/network/local/cache.dart';
import 'package:uuid/uuid.dart';

class DeviceUUid {
  Future<String> getUniqueDeviceId() async {
    String uniqueDeviceId = '';

    const uuid = Uuid();
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      // import 'dart:io'
      final iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueDeviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}'; // unique ID on iOS
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueDeviceId = '${androidDeviceInfo.model}:${androidDeviceInfo.id}'; // unique ID on Android
    }
    if (uniqueDeviceId == '') {
      uniqueDeviceId = await userCache?.get('device_id') ?? '';
      if (uniqueDeviceId == '') {
        uniqueDeviceId = uuid.v4();
        await userCache?.put(deviceIdKey, uniqueDeviceId);
      }
    }

    return uniqueDeviceId;
  }
}
