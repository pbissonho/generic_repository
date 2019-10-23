import 'package:generic_repository/src/model.dart';

abstract class IDataClient {
  Future<void> patch(String path, {dynamic data, IQueryParams queryParameters});

  Future<Map<String, dynamic>> get(String path, {IQueryParams queryParameters});

  Future<Map<String, dynamic>> put(String path,
      {dynamic data, IQueryParams queryParameters});

  Future<Map<String, dynamic>> delete(String path,
      {IQueryParams queryParameters});

  Future<Map<String, dynamic>> post(String path,
      {dynamic data, Map<String, dynamic> queryParameters});

  Future<List<Map<String, dynamic>>> getListMap(String path,
      {IQueryParams queryParameters});
}
