import 'utils.dart';

abstract class Model {
  Map<String, dynamic> toJson();
}

abstract class Arguments {
  Map<String, dynamic> toJson();

  String getUrlArguments() {
    return StringUtils.mapToUrlQueryFormat(toJson());
  }
}
