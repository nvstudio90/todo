import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keeps only a salted SHA-256 of the parent PIN, never the digits.
class PinRepository {
  PinRepository([SharedPreferencesAsync? prefs])
    : _prefs = prefs ?? SharedPreferencesAsync();

  static const _hashKey = 'pin_hash';
  static const _saltKey = 'pin_salt';

  final SharedPreferencesAsync _prefs;

  Future<bool> hasPin() async => await _prefs.getString(_hashKey) != null;

  Future<void> setPin(String pin) async {
    final random = Random.secure();
    final salt = base64Encode([
      for (var i = 0; i < 16; i++) random.nextInt(256),
    ]);
    await _prefs.setString(_saltKey, salt);
    await _prefs.setString(_hashKey, _hash(salt, pin));
  }

  Future<bool> verify(String pin) async {
    final salt = await _prefs.getString(_saltKey);
    final hash = await _prefs.getString(_hashKey);
    if (salt == null || hash == null) return false;
    return _hash(salt, pin) == hash;
  }

  static String _hash(String salt, String pin) =>
      sha256.convert(utf8.encode('$salt:$pin')).toString();
}
