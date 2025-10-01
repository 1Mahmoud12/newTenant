import 'dart:convert';
import 'dart:developer';

import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/feature/auth/data/models/register_model.dart';
import 'package:dobzz_seller/feature/auth/manager/authBloc/auth_cubit.dart';
import 'package:dobzz_seller/main.dart';
import 'package:local_auth/local_auth.dart';

enum BiometricTypeSimple { none, face, fingerprint, iris, weak, strong }

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isDeviceSupported() async {
    try {
      final isSupported = await _auth.isDeviceSupported();
      log('Biometric device supported: $isSupported');
      return isSupported;
    } catch (e) {
      log('Error checking device support: $e');
      return false;
    }
  }

  Future<bool> canCheckBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      log('Can check biometrics: $canCheck');
      return canCheck;
    } catch (e) {
      log('Error checking biometrics availability: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final biometrics = await _auth.getAvailableBiometrics();
      log('Available biometrics: $biometrics');
      return biometrics;
    } catch (e) {
      log('Error getting available biometrics: $e');
      return <BiometricType>[];
    }
  }

  Future<BiometricTypeSimple> getPreferredBiometricType() async {
    final biometrics = await getAvailableBiometrics();
    if (biometrics.contains(BiometricType.strong)) {
      return BiometricTypeSimple.strong;
    }
    if (biometrics.contains(BiometricType.weak)) {
      return BiometricTypeSimple.weak;
    }
    if (biometrics.contains(BiometricType.face)) {
      return BiometricTypeSimple.face;
    }
    if (biometrics.contains(BiometricType.fingerprint)) {
      return BiometricTypeSimple.fingerprint;
    }
    if (biometrics.contains(BiometricType.iris)) {
      return BiometricTypeSimple.iris;
    }
    return BiometricTypeSimple.none;
  }

  Future<bool> authenticate({String reason = 'Authenticate to continue'}) async {
    try {
      return await _auth.authenticate(localizedReason: reason, options: const AuthenticationOptions(stickyAuth: true));
    } catch (e) {
      log('Biometric authentication error: $e');
      return false;
    }
  }

  Future<void> enableBiometricLogin(RegisterModel loginModel) async {
    final selectedType = await getPreferredBiometricType();
    await loginCache?.put(biometricEnabledKey, true);
    await loginCache?.put(biometricTypeKey, selectedType.name);
    await loginCache?.put(biometricUserCacheKey, jsonEncode(loginModel.toJson()));
    await loginCache?.put(biometricAuthKey, loginModel.data?.token ?? '');

    if (userCacheValue?.data?.email == await userCache?.get(loginEmailKey)) {
      await loginCache?.put(loginEmailKey, userCacheValue?.data?.email ?? '');
      await loginCache?.put(loginPasswordKey, await loginCache?.get(loginPasswordKey));
    } else {
      await loginCache?.put(loginEmailKey, loginModel.data?.email ?? '');
      await loginCache?.put(loginPasswordKey, await loginCache?.get(alternativeLoginPasswordKey));
    }
  }

  Future<void> disableBiometricLogin() async {
    await loginCache?.put(biometricEnabledKey, false);
    await loginCache?.put(biometricTypeKey, 'none');
    await loginCache?.put(biometricUserCacheKey, '{}');
    await loginCache?.put(biometricAuthKey, '');
  }

  Future<bool> isBiometricEnabled() async {
    return loginCache?.get(biometricEnabledKey, defaultValue: false) ?? false;
  }

  Future<String?> getSavedAuthKey() async {
    return loginCache?.get(biometricAuthKey, defaultValue: '');
  }

  Future<RegisterModel?> getSavedUser() async {
    try {
      final String raw = await loginCache?.get(biometricUserCacheKey, defaultValue: '{}');
      if (raw.isEmpty || raw == '{}') return null;
      return RegisterModel.fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  Future<bool> attemptBiometricLogin() async {
    try {
      log('Starting biometric login attempt...');

      final bool enabled = await isBiometricEnabled();
      log('Biometric enabled: $enabled');
      if (!enabled) return false;

      final bool supported = await isDeviceSupported();
      log('Device supported: $supported');
      if (!supported) return false;

      final bool canCheck = await canCheckBiometrics();
      log('Can check biometrics: $canCheck');
      if (!canCheck) return false;

      log('Attempting authentication...');
      final bool ok = await authenticate(reason: 'Use biometrics to login');
      log('Authentication result: $ok');
      if (!ok) return false;

      log('Getting saved credentials...');
      final String? key = await getSavedAuthKey();
      final RegisterModel? user = await getSavedUser();
      log('Saved key exists: ${key != null && key.isNotEmpty}');
      log('Saved user exists: ${user != null}');

      if (key == null || key.isEmpty || user == null) return false;
      final cubit = AuthCubit();
      cubit.phoneController.text = await loginCache?.get(loginEmailKey);
      //   cubit.passwordController.text = await loginCache?.get(loginPasswordKey);
      final result = cubit.login(
        navigatorKey.currentState!.context,
      );
      // Set global models for in-app session reuse
      // userCacheValue = user;
      // ConstantsModels.loginModel = user;
      // Constants.token = key;
      // await userCache?.put(userCacheKey, jsonEncode(user.toJson()));

      log('Biometric login successful!');
      return result;
    } catch (e) {
      log('Error during biometric login: $e');
      return false;
    }
  }
}
