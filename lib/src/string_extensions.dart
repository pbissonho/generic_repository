/*
class StringEx {
  static String toUrlQueryFormat(Map<String, dynamic> arguments) {
    StringBuffer stringBuffer = new StringBuffer('');

    arguments.forEach((key, value) {
      if (value != null && value != '') {
        stringBuffer.write('$key=$value');
        stringBuffer.write('&');
      }
    });

    return stringBuffer.toString();
  }
}
*/
class QueryParams {
  static String fromMap(Map<String, dynamic> map) {
    StringBuffer stringBuffer = new StringBuffer('');

    map.forEach((key, value) {
      if (value != null && value != '') {
        stringBuffer.write('$key=$value');
        stringBuffer.write('&');
      }
    });

    return stringBuffer.toString();
  }
}
