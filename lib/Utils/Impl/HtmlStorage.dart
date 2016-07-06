library ClientCommon.Utils.Impl.HtmlStorage;
export '../Interfaces/IStorage.dart';
import '../Interfaces/IStorage.dart';

import 'dart:html';

class HtmlLocalStorage implements IStorage {
  Storage _storage = window.localStorage;
  
  @override
  Get(String key) => _storage[key];

  @override
  Set(String key, value) {
    _storage[key] = value;
  }

  @override
  Remove(String key) {
    _storage.remove(key);
  }
}