import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_security_storage.dart';

class FlutterSecureStorageLocalStorageImpl implements LocalSecurityStorage {
  FlutterSecureStorage get _instance => const FlutterSecureStorage();

  @override
  Future<void> clear() => _instance.deleteAll();

  @override
  Future<bool> contains(String key) => _instance.containsKey(key: key);

  @override
  Future<String?> read(String key) => _instance.read(key: key);

  @override
  Future<void> remove(String key) => _instance.delete(key: key);

  @override
  Future<void> write(String key, String value) =>
      _instance.write(key: key, value: value);
}
