library ClientCommon.Utils.Interfaces.IStorage;

export 'package:cork/cork.dart';
export 'dart:async';
export 'ICommunicator.dart';
import 'dart:async';
import 'package:cork/cork.dart';

import 'ICommunicator.dart';

@Inject()
abstract class IStorage {
  dynamic Get(String key);
  Set(String key, dynamic value);
  Remove(String key);
}