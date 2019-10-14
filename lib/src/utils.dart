class StringUtils {
  static String mapToUrlQueryFormat(Map<String, dynamic> arguments) {
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
