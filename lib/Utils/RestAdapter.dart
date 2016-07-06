library ClientCommon.Utils.RestDapater;

import 'Interfaces/IRestAdapter.dart';
import 'Interfaces/ICommunicator.dart';
import 'HttpCommunicator/HttpUtils.dart';
import 'dart:convert';
import 'dart:async';

class RestAdapter implements IRestAdapter {
  ICommunicator _Man;

  RestAdapter(this._Man) {}

  @override
  Future<dynamic> Get(String url, {bool credentials : true }) {
    Completer<dynamic> compl = new Completer();
    HttpRequestAdapter req = new HttpRequestAdapter.Get(url);
    req.SetCredentials(credentials);
    _Man.SendRequest(req).then((IResponse resp) {
      if (resp.Status == IResponse.OK) {
        var repr = JSON.decode(resp.Data);
        compl.complete(repr);
      } else {
        compl.completeError(resp);
      }
    }).catchError((error) => compl.completeError(error));

    return compl.future;
  }

  @override
  Future<String> Create(String url,
                        [Map<String, dynamic> params = null,
                         dynamic blob= null]) {
    Completer<String> compl = new Completer();
    final Map<String, dynamic> args = params != null ? params : new Map();

    HttpRequestAdapter req = new HttpRequestAdapter.Post(url, args, blob);
    _Man.SendRequest(req).then((IResponse resp) {
      if (resp.Status == IResponse.OK) {
        final String id = resp.Data;
        compl.complete(id);
      } else {
        compl.completeError(resp);
      }
    }).catchError((error) => compl.completeError(error));

    return compl.future;
  }

  @override
  Future<String> Delete(String url) {
    Completer<String> compl = new Completer();
    HttpRequestAdapter req = new HttpRequestAdapter.Delete(url);
    _Man.SendRequest(req).then((IResponse resp) {
      if (resp.Status == IResponse.OK) {
        compl.complete(url);
      } else {
        compl.completeError(resp);
      }
    }).catchError((error) => compl.completeError(error));

    return compl.future;
  }

  @override
  Future<String> Update(String url,
                        [Map<String, dynamic> params = null,
                         dynamic blob= null]) {
    Completer<String> compl = new Completer();
    final Map<String, dynamic> args = params != null ? params : new Map();

    HttpRequestAdapter req = new HttpRequestAdapter.Put(url, args, blob);
    _Man.SendRequest(req).then((IResponse resp) {
      if (resp.Status == IResponse.OK) {
        compl.complete(url);
      } else {
        compl.completeError(resp);
      }
    }).catchError((error) => compl.completeError(error));

    return compl.future;
  }

  @override
  ICommunicator GetCommunicator() {
    return _Man;
  }
}
