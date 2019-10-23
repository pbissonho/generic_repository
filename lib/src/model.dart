abstract class Model {
  Map<String, dynamic> toJson();
}

abstract class IQueryParams {
  String toQueryParams();
  Map<String, dynamic> toMap();
}
