library ClientCommon.Utils.HttpCommunicator;

export 'HttpUtils.dart';

import '../Interfaces/ICommunicator.dart';
import 'HttpUtils.dart';
import 'dart:core';
import 'dart:async';
import 'dart:html';
import 'dart:convert';

typedef void IntRequest(HttpRequestAdapter);
typedef String TEncoder(Map<String, dynamic> data, {HttpRequestAdapter request});

class HttpCommunicator implements ICommunicator {
  Map<RequestType, IntRequest> _TypeAdapters;
  Map<String, String> _DefaultHeaders;
  TEncoder _encoder;

  HttpCommunicator() {
    _encoder =_encodeToFormData;
    _DefaultHeaders = new Map();
    _TypeAdapters = new Map();
    _TypeAdapters[RequestType.POST] = _sendPostRequest;
    _TypeAdapters[RequestType.GET] = _sendGetRequest;
    _TypeAdapters[RequestType.PUT] = _sendPutRequest;
    _TypeAdapters[RequestType.DELETE] = _sendDeleteRequest;
  }

  Map<RequestType, IntRequest> get ReqAdapter => _TypeAdapters;

  setEncoder(TEncoder encoder) {
    _encoder = encoder;
  }

  String _encodeToFormData(Map<String, dynamic> data, {HttpRequestAdapter request})
  {
    var parts = [];
    data.forEach((key, value) {
      String finalValue = null;
      if(value is Map || value is List) {
        finalValue = JSON.encode(value);
      }
      finalValue??='${Uri.encodeQueryComponent(value.toString())}';
      parts.add('${Uri.encodeQueryComponent(key)}=${finalValue}');
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

  Future<HttpResponseAdapter> SendRequest(IRequest request)
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

  Future<HttpResponseAdapter>
    _sendGenericRequest(HttpRequestAdapter request, String method) {
        if(request.Credentials) {
          request.Headers.addAll(_DefaultHeaders);
        }
        var reqData = null;
        if(request.Blob != null) {
          reqData = request.Blob;
          request.Headers.remove('Content-type');
        } else {
          reqData = _encoder(request.Args);
        }

        Completer<HttpResponseAdapter>
          comleter = new Completer<HttpResponseAdapter>();

        HttpRequest.
                   request(request.Url,
                           method: method,
                           withCredentials: request.Credentials,
                           requestHeaders: request.Headers,
                           sendData: reqData).
                             then((HttpRequest req)
                                  {
                                    HttpResponseAdapter
                                      ret = new HttpResponseAdapter(req);
                                    comleter.complete(ret);
        }).catchError((error){
          HttpRequest req = error.target;
          HttpResponseAdapter errorReq = new HttpResponseAdapter(req);
          comleter.completeError(errorReq);
        });
        return comleter.future;
  }

  Future<HttpResponseAdapter> _sendPostRequest(HttpRequestAdapter request) {
    return _sendGenericRequest(request, "POST");
  }

  Future<HttpResponseAdapter> _sendPutRequest(HttpRequestAdapter request) {
      return _sendGenericRequest(request, "PUT");
    }

  Future<HttpResponseAdapter> _sendGetRequest(HttpRequestAdapter request) {
      return _sendGenericRequest(request, "GET");
  }

  Future<HttpResponseAdapter> _sendDeleteRequest(HttpRequestAdapter request) {
      return _sendGenericRequest(request, "DELETE");
  }
}
