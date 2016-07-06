library ClientCommon.Utils.StreamClient.BrowserStreamClient;

import 'dart:html';
import 'dart:async';


class StreamClient  {
  WebSocket socket;
  String _url;
  var _protocols;
  StreamSubscription _connctionSub;
  StreamController<MessageEvent> _streamCntr = new StreamController();
  Stream<MessageEvent> onMessage;
  
  StreamClient(this._url, [this._protocols = null])
  {
    onMessage = _streamCntr.stream;
  }
  
  Future<bool> _onLogin(MessageEvent message) async {
    final String data = message.data; 
    if (data == 'success') {
      onMessage = socket.onMessage;
      _connctionSub.cancel();
      return true;
    } else {
      throw data;
    }
    return false;
  }
  
  _onMessage(MessageEvent message) {
    _streamCntr.add(message);
  }
  
  Future Connect({String authToken: null}) {
    Completer comp = new Completer();
    socket = new WebSocket(this._url);
    
    StreamSubscription subs = socket.onOpen.listen((Event e){
      socket.sendString(authToken == null ? '' : authToken);
    });
    
    _connctionSub = socket.onMessage.listen((MessageEvent message){
      _onLogin(message).then((bool res){
        if (res) comp.complete();
        subs.cancel();
      });
    });

    return comp.future;
  }
  
  void SendMessage(String message) {
    socket.sendString(message);
  }
  
  
}


