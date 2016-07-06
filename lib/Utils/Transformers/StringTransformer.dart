library ClientCommon.Utils.Transformers.StringTransformer;

import 'package:polymer_expressions/filter.dart';

class S2D extends Transformer<String, double> {
  @override
  String forward(double v) {
    if(v.abs() > v.abs().truncate()) {
      return "$v";
    } else {
      return "${v.truncate()}";
    }
  }

  @override
  double reverse(String t) {
    try {
      return double.parse(t);
    } catch(error) {}
    
    return null;
  }
}

class S2Int extends Transformer<String, int> {
  @override
  String forward(int v) {
    return "$v";
  }

  @override
  int reverse(String t) {
    try {
      return int.parse(t);
    } catch(error) {}
    return null;
  }
}

class S2Currency extends Transformer<String, num> {
  @override
  String forward(num v) {
    String res = "";
    if(v.abs() > v.abs().truncate()) {
      res = "$v";
    } else {
      res = "${v.truncate()}";
    }
    
   
    
    List<String> parts = new List();
    
    int start = res.length;
    
    int counter = 1;
    
    for(int ind = start - 1; ind >= 0; --ind) {
      if(counter == 3) {
        parts.add(res.substring(ind, ind + 3));
        counter = 1;
      } else {
        ++counter;
      }
    }
    
    if (res.length % 3 != 0) {
      parts.add(res.substring(0, res.length - (parts.length * 3)));
    }
    
    res = "";
    start = 0;
    for(String part in parts.reversed) {
      if(start!=0) res += " $part";
      else res += part;
      ++start;
    }
    
    return res;
  }

  @override
  num reverse(String t) {
    return num.parse(t);
  }
}

class S2Null extends Transformer<String, dynamic> {
  @override
  String forward(dynamic v) {
    return "$v";
  }

  @override
  dynamic reverse(String t) {
    return null;
  }
}

class S2Break extends Transformer<String, dynamic> {
  @override
  String forward(dynamic v) {
    return "$v";
  }

  @override
  dynamic reverse(String t) {
    assert(false);
    return null;
  }
}