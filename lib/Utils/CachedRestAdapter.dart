library ClientCommon.Utils.CachedRestAdapter;

export 'Interfaces/IRestAdapter.dart';

import 'Interfaces/IRestAdapter.dart';
import 'Interfaces/ICommunicator.dart';
import 'RestAdapter.dart';

import 'dart:convert';
import 'dart:async';
import 'dart:html';
import 'dart:indexed_db';

import 'package:harvest/harvest.dart';
import 'package:crypto/crypto.dart';

import 'Events/Events.dart';

Map<String, dynamic> _cachedData = {};

class CachedRestAdapter implements IRestAdapter {
  final String _DbName = "Semplex.Investments";
  final int _DbVersion = 1;
  Database _Db = null;
  RestAdapter _remote;
  MessageBus bus;
  bool cacheEnable;

  static String GetTarget(String url) {
    final Uri target = Uri.parse(url);
    return target.pathSegments.last;
  }

  static String getHash(String url) {
    Hash hasher = new MD5();
    hasher.add(url.codeUnits);
    return CryptoUtils.bytesToHex(hasher.close());
  }

  CachedRestAdapter(ICommunicator gateway,
                    {this.cacheEnable: false, this.bus: null})
  {
    _remote = new RestAdapter(gateway);

    if(IdbFactory.supported) {
      _Open().then((Database db) => _Db = db);
    } else {
      window.console.error("IndexedDB not avaliable");
    }
    if(bus != null) {
      _initListeners();
    }
  }

  _initListeners() {
    bus.stream(SysEvent)
       .where((SysEvent evt) => evt.type == TEvt.ENTITY_CHANGE)
       .listen((SysEvent evt)
    {
      final String hash = getHash(evt.data);
      _cachedData.remove(hash);
    });
  }

  void _initializeDatabase(VersionChangeEvent e) {

  }

  Future<Database> _Open() {
    return window.indexedDB.open(_DbName,
                                 version: _DbVersion,
                                 onUpgradeNeeded: _initializeDatabase);
  }

  @override
  Future<String> Create(String url,
                        [Map<String, dynamic> params = null,
                         dynamic blob= null]) {
    return _remote.Create(url, params, blob);
  }

  @override
  Future<String> Delete(String url) {
    final String hash = getHash(url);
    _cachedData.remove(hash);
    return _remote.Delete(url);
  }

  @override
  Future<dynamic> Get(String url, {bool credentials : true }) {
    final String hash = getHash(url);
    /*-----*/
    if(!cacheEnable) {
      return _remote.Get(url, credentials: credentials);
    }
    /*----*/
    print("Cached rest: ${url} : hash - ${hash}");
    if(_cachedData.containsKey(hash)) {
      print("get from cache");
      return new Future.value(_cachedData[hash]);
    } else {
      return _remote.Get(url, credentials: credentials).then((data){
        _cachedData[hash] = data;
        return new Future.value(data);
      });
    }
  }

  @override
  Future<String> Update(String url,
                        [Map<String, dynamic> params = null,
                         dynamic blob= null]) {
    final String hash = getHash(url);
    _cachedData.remove(hash);
    return _remote.Update(url, params, blob);
  }

  @override
  ICommunicator GetCommunicator() {
    return _remote.GetCommunicator();
  }
}
