import 'package:dio/dio.dart';
import 'package:generic_repository/src/core/error/exceptions.dart';
import 'data_client.dart';
import 'model.dart';

class DioDataClient implements IDataClient {
  final Dio dio;

  DioDataClient(this.dio);

  Dio get dioClient => dio;

  @override
  Future<void> delete(String path,
      {Map<String, dynamic> queryParameters}) async {
    await dio.delete(path, queryParameters: queryParameters);
  }

  @override
  Future<Map<String, dynamic>> get(String path, {Arguments arguments}) async {
    try {
      var dioResponse = await dio.get("/$path?${arguments?.getUrlArguments()}");

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
      {Arguments arguments}) async {
    try {
      var dioResponse = await dio.get("/$path?${arguments?.getUrlArguments()}");

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
  Future patch(String path,
      {data, Map<String, dynamic> queryParameters}) async {
    await dio.patch(path, data: data, queryParameters: queryParameters);
  }

  @override
  Future<void> post(String path,
      {data, Map<String, dynamic> queryParameters}) async {
    await dio.post(path, data: data, queryParameters: queryParameters);
  }

  @override
  Future<void> put(String path,
      {data, Map<String, dynamic> queryParameters}) async {
    await dio.put(path, data: data, queryParameters: queryParameters);
  }
}
