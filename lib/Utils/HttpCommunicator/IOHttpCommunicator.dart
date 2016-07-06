library ClientCommon.Utils.IoHttpCommunicator;

export 'HttpUtils.dart';

import '../Interfaces/ICommunicator.dart';
import 'HttpUtils.dart';
import "dart:io";
import "dart:convert";
import 'dart:core';
import 'dart:async';

class IoHttpResponseAdapter implements IResponse {
  HttpClientResponse _response;
  String _data = "";
  Map<String, String> _headers = new Map();
  IoHttpResponseAdapter(this._response, [this._data]) {
    _response.headers.forEach((String name, List<String> values){
      _headers[name] = values[0];
    });
  }

  int get Status => _response.statusCode;
  dynamic get Data => _data;
  Map<String, String> get Headers => _headers;
  dynamic get Internal => _response;
}

typedef void IntRequest(HttpRequestAdapter);

class IoHttpCommunicator implements ICommunicator {
  Map<RequestType, IntRequest> _TypeAdapters;
  Map<String, String> _DefaultHeaders;

  HttpClient _client;

  IoHttpCommunicator() {
    _client = new HttpClient();
    _init();
  }

  IoHttpCommunicator.withHttpClient(this._client) {
    _init();
  }

  _init() {
    _DefaultHeaders = new Map();
    _TypeAdapters = new Map();
    _TypeAdapters[RequestType.POST] = _sendPostRequest;
    _TypeAdapters[RequestType.GET] = _sendGetRequest;
    _TypeAdapters[RequestType.PUT] = _sendPutRequest;
    _TypeAdapters[RequestType.DELETE] = _sendDeleteRequest;
  }

  Map<RequestType, IntRequest> get ReqAdapter => _TypeAdapters;

  String _encodeToFormData(Map<String, dynamic> data)
  {
    var parts = [];
    data.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value.toString())}');
    });
    return parts.join('&');
  }

  void AddDefaultHeaders(String name, String value) {
    _DefaultHeaders[name] = value;
  }

  @override
  String GetDefaultHeaders(String name) {
    assert(_DefaultHeaders.containsKey(name));
    return _DefaultHeaders[name];
  }

  Future<IoHttpResponseAdapter> SendRequest(IRequest request)
  {
    if (request is HttpRequestAdapter) {
      HttpRequestAdapter httpReq = request as HttpRequestAdapter;

      if (ReqAdapter.containsKey(httpReq.Type)) {
        return ReqAdapter[httpReq.Type](httpReq);
      }
      assert(false);
    } else {
      assert(false);
    }
  }

  Future<IoHttpResponseAdapter>
    _sendGenericRequest(HttpRequestAdapter request, String method) {
        request.Headers.addAll(_DefaultHeaders);
        final String reqData = _encodeToFormData(request.Args);

        Completer<IoHttpResponseAdapter>
          comleter = new Completer<IoHttpResponseAdapter>();

        Uri uri = Uri.parse(request.Url);
        String path = uri.path;
        if(uri.query.isNotEmpty) {
          path = "$path?${uri.query}";
        }
        _client.open(method, uri.host, uri.port, path).then((HttpClientRequest req){
          request.Headers.forEach((String key, String value){
            req.headers.add(key, value);
          });
          if (method == "POST" || method == "PUT" || method == "DELETE") {
            String data = _encodeToFormData(request.Args);
            req.write(data);
          }
          return req.close();
        }).then((HttpClientResponse resp){
          StringBuffer sb = new StringBuffer();
          resp.transform(new Utf8Decoder(allowMalformed: true))
            .listen((String data){
              sb.write(data);
            }).onDone((){
              var data = sb.toString();
              try {
                IoHttpResponseAdapter ret = new IoHttpResponseAdapter(resp, data);
                comleter.complete(ret);
              }
              catch(e) { throw e;}
          });
        }).catchError((error){
          comleter.completeError(error);
        });

        return comleter.future;
  }

  Future<IoHttpResponseAdapter> _sendPostRequest(HttpRequestAdapter request) {
    return _sendGenericRequest(request, "POST");
  }

  Future<IoHttpResponseAdapter> _sendPutRequest(HttpRequestAdapter request) {
      return _sendGenericRequest(request, "PUT");
    }

  Future<IoHttpResponseAdapter> _sendGetRequest(HttpRequestAdapter request) {
      return _sendGenericRequest(request, "GET");
  }

  Future<IoHttpResponseAdapter> _sendDeleteRequest(HttpRequestAdapter request) {
      return _sendGenericRequest(request, "DELETE");
  }

}
