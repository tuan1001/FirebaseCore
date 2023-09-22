import 'package:flutter_secure_storage/flutter_secure_storage.dart';

mixin StoreLocal {
  static FlutterSecureStorage? _storage;

  static Future<void> getInstance() async {
    AndroidOptions androidOptions = const AndroidOptions(encryptedSharedPreferences: true);
    IOSOptions iosOptions = const IOSOptions(accessibility: KeychainAccessibility.first_unlock);
    _storage = FlutterSecureStorage(aOptions: androidOptions, iOptions: iosOptions);
  }

  static Future<void> setString({required String key, required String value}) async {
    await _storage?.write(key: key, value: value);
  }

  static Future<String?> getString({required String key}) async {
    return await _storage?.read(key: key);
  }

  static Future<void> remove({required String key}) async {
    await _storage?.delete(key: key);
  }

  static Future<void> clear() async {
    await _storage?.deleteAll();
  }

  static Future<void> setBool({required String key, required bool value}) async {
    await _storage?.write(key: key, value: value.toString());
  }

  static Future<bool?> getBool({required String key}) async {
    String? value = await _storage?.read(key: key);
    return value == 'true';
  }

  static Future<void> setInt({required String key, required int value}) async {
    await _storage?.write(key: key, value: value.toString());
  }

  static Future<int?> getInt({required String key}) async {
    String? value = await _storage?.read(key: key);
    return int.tryParse(value ?? '');
  }
}
