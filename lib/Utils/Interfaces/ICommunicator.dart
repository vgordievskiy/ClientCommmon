library ClientCommon.Utils.Interfaces.ICommunicator;

import 'dart:async';

abstract class IRequest {
  String get Url;
  Map<String, String> get Args;
  dynamic get Blob;
  Map<String, String> get Headers;

  bool get Credentials;
  void SetCredentials(bool flag);
}

abstract class IResponse {
  static final int OK = 200;

  int get Status;
  dynamic get Data;
  Map<String, String> get Headers;
  dynamic get Internal;
}

abstract class ICommunicator {
  Future<IResponse> SendRequest(IRequest request);
  void AddDefaultHeaders(String name, String value);
  String GetDefaultHeaders(String name);
}
