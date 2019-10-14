import 'package:dio/dio.dart';
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
    var dioResponse = await dio.get("/$path?${arguments?.getUrlArguments()}");
    return dioResponse.data;
  }

  @override
  Future<List<Map<String, dynamic>>> getListMap(String path,
      {Arguments arguments}) async {
    var dioResponse = await dio.get("/$path?${arguments?.getUrlArguments()}");

    var listMap = List<Map<String, dynamic>>.from(dioResponse.data);
    return listMap;
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
