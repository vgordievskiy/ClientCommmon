library wrike_test.Utils.Transformers.RegexpVerifier;

import 'dart:async';
import 'dart:core';
import 'package:polymer_expressions/filter.dart';

export 'dart:core';

class RegexpVerifier extends Transformer<String, String> {
  final StreamController _errors = new StreamController();
  final StreamController _values = new StreamController();

  RegExp matcher;
  
  Stream get errors => _errors.stream;
  Stream get values => _values.stream;

  RegexpVerifier(this.matcher);
  
  bool hasMatch(String val) => val.isEmpty || matcher.hasMatch(val);
  
  @override
  String forward(String v) {
    return "$v";
  }

  @override
  String reverse(String t) {
    String ret = "";
    if(hasMatch(t)) {
      _values.add(t);
      ret = t;
    } else {
      _errors.add(t);
    }
    return ret;
  }
}
