import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorage {
  //to singleton
  static final SecuredStorage instance = SecuredStorage._internal();
  factory SecuredStorage() {
    return instance;
  }
  SecuredStorage._internal();

/// Create storage
  final storage = const FlutterSecureStorage();

/// Write value
  Future<void> write(String key, String? value) async {
    // print('writing data to $key as $value');
    await storage.write(key: key, value: value);
  }

/// Read value
  Future<String?> read(key) async {
    return await storage.read(key: key);
  }

/// Delete value
 Future<void>  delete(key) async {
    await storage.delete(key: key);
  }
}
