import 'package:dio/dio.dart';
import 'package:generic_repository/src/core/error/exceptions.dart';
import 'data_client.dart';
import 'interfaces/query_params.dart';

class DioDataClient implements IDataClient {
  final Dio dio;

  DioDataClient(this.dio);

  Dio get dioClient => dio;

  dynamic dataWhenRead(dynamic data) {
    return data;
  }

  dynamic dataWhenReadMany(dynamic data) {
    return data;
  }

  @override
  Future<Map<String, dynamic>> delete(String path,
      {IQueryParams queryParameters}) async {
    var response =
        await dio.delete(path, queryParameters: queryParameters.toMap());
    return dataWhenRead(response.data);
  }

  @override
  Future<Map<String, dynamic>> read(String path,
      {IQueryParams queryParameters}) async {
    try {
      var response =
          await dio.get("/$path?${queryParameters?.toQueryParams()}");

      if (response.statusCode != 200) {
        throw new RestException("DioResponse status code deve ser 200");
      }

      if (response.data is Map<String, dynamic>) {
        return dataWhenRead(response.data);
      } else {
        throw new RestException(
            "DioResponse.data deve ser of type Map<String, dynamic>");
      }
    } on DioError catch (error) {
      throw new RestException(error.message);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readMany(String path,
      {IQueryParams queryParameters}) async {
    try {
      var dioResponse =
          await dio.get("/$path?${queryParameters?.toQueryParams()}");

      if (dioResponse.statusCode != 200) {
        throw new RestException("DioResponse status code deve ser 200");
      }
      var data = dataWhenReadMany(dioResponse.data);
      var listMap = List<Map<String, dynamic>>.from(data);
      return listMap;
    } on DioError catch (error) {
      throw new RestException(error.message);
    }
  }

  @override
  Future<Map<String, dynamic>> patch(String path,
      {data, IQueryParams queryParameters}) async {
    var response = await dio.patch(path,
        data: data, queryParameters: queryParameters.toMap());
    return dataWhenRead(response.data);
  }

  @override
  Future<Map<String, dynamic>> create(String path,
      {data, Map<String, dynamic> queryParameters}) async {
    var response =
        await dio.post(path, data: data, queryParameters: queryParameters);
    return dataWhenRead(response.data);
  }

  @override
  Future<Map<String, dynamic>> update(String path,
      {data, IQueryParams queryParameters}) async {
    var response = await dio.put(path,
        data: data, queryParameters: queryParameters.toMap());
    return response.data;
  }
}
