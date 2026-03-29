import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

class PinService {
  final _storage = const FlutterSecureStorage();
  static const _pinKey = 'routino_secure_pin_hash';

  String _hashPin(String pin) {
    var bytes = utf8.encode(pin);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> savePin(String pin) async {
    final hashed = _hashPin(pin);
    await _storage.write(key: _pinKey, value: hashed);
  }

  Future<bool> verifyPin(String enteredPin) async {
    final storedHash = await _storage.read(key: _pinKey);
    if (storedHash == null) return false;
    
    final enteredHash = _hashPin(enteredPin);
    return storedHash == enteredHash;
  }

  Future<bool> hasPin() async {
    final storedHash = await _storage.read(key: _pinKey);
    return storedHash != null;
  }

  Future<void> deletePin() async {
    await _storage.delete(key: _pinKey);
  }
}
