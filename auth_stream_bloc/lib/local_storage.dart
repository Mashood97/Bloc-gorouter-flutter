import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'di_container.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory LocalStorage() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  LocalStorage._internal();

  final FlutterSecureStorage _storageInstance =
      getItInstance.get<FlutterSecureStorage>();

/*-----------Local Storage Keys------------*/
  final String _cacheAutoLoginKey = "cache_auto_login_key";

  Future<void> writeAutoLoginKey({required String autoLogin}) async {
    await _storageInstance.write(
      key: _cacheAutoLoginKey,
      value: autoLogin,
    );
  }

  Future<String> readAutoLoginKey() async {
    return await _storageInstance.read(
          key: _cacheAutoLoginKey,
        ) ??
        "";
  }

  /*Clear whole app data from local storage*/

  Future<void> clearLocalStorage() async {
    _storageInstance.deleteAll(
      aOptions: getAndroidOptions(),
    );
  }
}
