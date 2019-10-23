import 'package:dio/dio.dart';
import 'package:generic_repository/src/core/error/exceptions.dart';
import 'data_client.dart';
import 'model.dart';

class DioDataClient implements IDataClient {
  final Dio dio;

  DioDataClient(this.dio);

  Dio get dioClient => dio;

  @override
  Future<Map<String, dynamic>> delete(String path,
      {IQueryParams queryParameters}) async {
    var response =
        await dio.delete(path, queryParameters: queryParameters.toMap());
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> get(String path,
      {IQueryParams queryParameters}) async {
    try {
      var dioResponse =
          await dio.get("/$path?${queryParameters?.toQueryParams()}");

      if (dioResponse.statusCode != 200) {
        throw new RestException("DioResponse status code deve ser 200");
      }

      if (dioResponse.data is Map<String, dynamic>) {
        return dioResponse.data;
      } else {
        throw new RestException(
            "DioResponse.data deve ser of type Map<String, dynamic>");
      }
    } on DioError catch (error) {
      throw new RestException(error.message);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getListMap(String path,
      {IQueryParams queryParameters}) async {
    try {
      var dioResponse =
          await dio.get("/$path?${queryParameters?.toQueryParams()}");

      if (dioResponse.statusCode != 200) {
        throw new RestException("DioResponse status code deve ser 200");
      }

      var listMap = List<Map<String, dynamic>>.from(dioResponse.data);
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
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> post(String path,
      {data, Map<String, dynamic> queryParameters}) async {
    var response =
        await dio.post(path, data: data, queryParameters: queryParameters);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> put(String path,
      {data, IQueryParams queryParameters}) async {
    var response = await dio.put(path,
        data: data, queryParameters: queryParameters.toMap());
    return response.data;
  }
}
