import 'package:generic_repository/src/model.dart';

abstract class IDataClient {
  Future<void> patch(String path,
      {dynamic data, Map<String, dynamic> queryParameters});

  Future<Map<String, dynamic>> get(String path, {Arguments arguments});

  Future<void> put(String path,
      {dynamic data, Map<String, dynamic> queryParameters});

  Future<void> delete(String path, {Map<String, dynamic> queryParameters});

  Future<void> post(String path,
      {dynamic data, Map<String, dynamic> queryParameters});

  Future<List<Map<String, dynamic>>> getListMap(String path,
      {Arguments arguments});
}
