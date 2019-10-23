import 'interfaces/query_params.dart';

abstract class IDataClient {
  Future<void> patch(String path, {dynamic data, IQueryParams queryParameters});

  Future<Map<String, dynamic>> read(String path,
      {IQueryParams queryParameters});

  Future<Map<String, dynamic>> update(String path,
      {dynamic data, IQueryParams queryParameters});

  Future<Map<String, dynamic>> delete(String path,
      {IQueryParams queryParameters});

  Future<Map<String, dynamic>> create(String path,
      {dynamic data, Map<String, dynamic> queryParameters});

  Future<List<Map<String, dynamic>>> readMany(String path,
      {IQueryParams queryParameters});
}
