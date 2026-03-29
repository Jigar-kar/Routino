import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../services/pin_service.dart';

enum AuthStatus { loading, setupNeeded, locked, unlocked }

final pinServiceProvider = Provider((ref) => PinService());

class AuthNotifier extends Notifier<AuthStatus> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  AuthStatus build() {
    _checkInitialState();
    return AuthStatus.loading;
  }

  Future<void> _checkInitialState() async {
    final service = ref.read(pinServiceProvider);
    final hasPin = await service.hasPin();
    if (hasPin) {
      state = AuthStatus.locked;
    } else {
      state = AuthStatus.setupNeeded;
    }
  }

  void lockApp() {
    if (state == AuthStatus.unlocked) {
      final service = ref.read(pinServiceProvider);
      service.hasPin().then((hasPin) {
        if (hasPin) state = AuthStatus.locked;
      });
    }
  }

  Future<bool> unlock(String enteredPin) async {
    final service = ref.read(pinServiceProvider);
    final isValid = await service.verifyPin(enteredPin);
    if (isValid) {
      state = AuthStatus.unlocked;
      return true;
    }
    return false;
  }

  /// Biometric auth is ALWAYS enabled for all users.
  /// Returns true if the device supports and has enrolled biometrics.
  Future<bool> canUseBiometric() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      if (!canCheck || !isDeviceSupported) return false;

      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> unlockWithBiometric() async {
    try {
      final canUse = await canUseBiometric();
      if (!canUse) return false;

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Use your fingerprint or face to unlock Routino',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        state = AuthStatus.unlocked;
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> setupPin(String pin) async {
    final service = ref.read(pinServiceProvider);
    await service.savePin(pin);
    state = AuthStatus.unlocked;
  }

  Future<void> resetPin() async {
    final service = ref.read(pinServiceProvider);
    await service.deletePin();
    state = AuthStatus.setupNeeded;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthStatus>(() {
  return AuthNotifier();
});
