library ClientCommon.Utils.Interfaces.IRestAdapter;

export 'package:cork/cork.dart';
export 'dart:async';
export 'ICommunicator.dart';
import 'dart:async';
import 'package:cork/cork.dart';

import 'ICommunicator.dart';

abstract class IRestAdapter {
  ICommunicator GetCommunicator();
  Future<dynamic> Get(String url, {bool credentials : true });
  Future<String> Create(String url,
                        [Map<String, dynamic> params = null,
                         dynamic blob= null]);
  Future<String> Delete(String url);
  Future<String> Update(String url,
                        [Map<String, dynamic> params = null,
                         dynamic blob= null]);
}
