import 'dart:convert';
import 'dart:developer';

import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/feature/auth/data/models/register_model.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';
import 'package:dobzz_seller/main.dart';
import 'package:flutter/material.dart';
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

  Future<bool> authenticate({
    String reason = 'Authenticate to continue',
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(stickyAuth: true),
      );
    } catch (e) {
      log('Biometric authentication error: $e');
      return false;
    }
  }

  Future<void> enableBiometricLogin(
    RegisterModel loginModel, {
    String? phone,
  }) async {
    final selectedType = await getPreferredBiometricType();
    await loginCache?.put(biometricEnabledKey, true);
    await loginCache?.put(biometricTypeKey, selectedType.name);
    await loginCache?.put(
      biometricUserCacheKey,
      jsonEncode(loginModel.toJson()),
    );
    await loginCache?.put(biometricAuthKey, loginModel.data?.token ?? '');

    // Save phone and password for biometric login
    if (loginModel.data?.email != null) {
      await loginCache?.put(loginEmailKey, loginModel.data?.email);
    }

    log('Biometric login enabled for user: ${loginModel.data?.email}');
  }

  Future<void> disableBiometricLogin() async {
    await loginCache?.put(biometricEnabledKey, false);
    await loginCache?.put(biometricTypeKey, 'none');
    await loginCache?.put(biometricUserCacheKey, '{}');
    await loginCache?.put(biometricAuthKey, '');
    // Also clear saved credentials so UI cannot infer enabled state
    await loginCache?.put(loginEmailKey, '');
    await loginCache?.put(loginPasswordKey, '');
    logger.d(await loginCache?.get(biometricEnabledKey));
  }

  Future<bool> isBiometricEnabled() async {
    logger.d(await loginCache?.get(biometricEnabledKey));

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

  Future<bool> attemptBiometricLogin(BuildContext context) async {
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

      // Prefer token-based fast login if available
      final RegisterModel? savedUser = await getSavedUser();
      final String? savedToken = await getSavedAuthKey();
      if (savedUser != null && savedToken != null && savedToken.isNotEmpty) {
        log('Logging in via saved token');
        // Hydrate global state
        ConstantsModels.registerModel = savedUser;
        // loginCacheValue = savedUser;
        Constants.token = savedToken;
        await loginCache?.put(loginCacheKey, jsonEncode(savedUser.toJson()));
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const NavigationViewWithThemes()),
            (route) => false,
          );
        } else {
          // fallback to context navigation
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const NavigationViewWithThemes()),
            (route) => false,
          );
        }
        return true;
      }

      // No password fallback in this system; depend solely on biometricEnabledKey + cached token
      log('No cached token found for biometric login');
      return false;
    } catch (e) {
      log('Error during biometric login: $e');
      return false;
    }
  }
}
