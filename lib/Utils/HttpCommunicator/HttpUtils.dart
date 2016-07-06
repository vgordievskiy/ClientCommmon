library ClientCommon.Utils.HttpCommunicator.Utils;

import '../Interfaces/ICommunicator.dart';

class RequestType {
  int Type = 0;
  RequestType(this.Type);
  static RequestType GET = new RequestType(0);
  static RequestType POST = new RequestType(1);
  static RequestType PUT = new RequestType(2);
  static RequestType DELETE = new RequestType(3);
}

class HttpRequestAdapter implements IRequest {

  RequestType _Type;
  String _Url;
  Map<String, String> _Args;
  dynamic _Blob;
  Map<String, String> _Headers;
  bool _withCredentials = true;

  HttpRequestAdapter.Get(String url) {
    _initBase(url, RequestType.GET);
    _Args = new Map();
  }

  HttpRequestAdapter.Put(String url, Map<String, String> args, dynamic blob)
  {
    _initBase(url, RequestType.PUT);
    _initArgs(args, blob);
  }

  HttpRequestAdapter.Post(String url, Map<String, String> args, dynamic blob)
  {
      _initBase(url, RequestType.POST);
      _initArgs(args, blob);
  }

  HttpRequestAdapter.Delete(String url,
                            {Map<String, String> args: null,
                             dynamic blob: null})
  {
      _initBase(url, RequestType.DELETE);
      _initArgs(args, blob);
  }

  void _initBase(String url, RequestType type) {
    _Url = url;
    _Type = type;
    _Headers = new Map();
    _Headers["Content-type"] = "application/x-www-form-urlencoded; charset=utf-8";
  }

  _initArgs(Map<String, String> args, dynamic blob) {
    if (blob != null) _Blob = blob;
    else {
      _Args = args == null ? new Map() : args;
    }
  }

  void _RequestDone() {

  }

  RequestType get Type => _Type;
  String get Url => _Url;
  Map<String, String> get Args => _Args;
  Map<String, String> get Headers => _Headers;
  get Blob => _Blob;
  bool get Credentials => _withCredentials;

  void SetCredentials(bool flag) { _withCredentials = flag; }
}

class HttpResponseAdapter implements IResponse {
  dynamic _Request;
  HttpResponseAdapter(dynamic req)
  {
    _Request = req;
  }

  int get Status => _Request.status;
  dynamic get Data => _Request.responseText;
  Map<String, String> get Headers => _Request.responseHeaders;
  dynamic get Internal => _Request;
}
