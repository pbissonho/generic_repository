import 'package:dio/dio.dart';
import 'package:generic_repository/src/core/error/exceptions.dart';
import 'package:generic_repository/src/dio_data_client.dart';
import 'package:test/test.dart';

void main() {
  test('get a list map from rest api', () async {
    BaseOptions options =
        BaseOptions(baseUrl: "https://jsonplaceholder.typicode.com/");
    Dio dio = Dio(options);

    var dataClient = DioDataClient(dio);

    var data = await dataClient.readMany("posts");

    expect(data, isNotNull);
    expect(data, isA<List<Map<String, dynamic>>>());
  });

  test('get a map from rest api', () async {
    BaseOptions options =
        BaseOptions(baseUrl: "https://jsonplaceholder.typicode.com/");
    Dio dio = Dio(options);

    var dataClient = DioDataClient(dio);

    var data = await dataClient.read("posts/1");

    expect(data, isNotNull);
    expect(data, isA<Map<String, dynamic>>());
  });

  test('get a map from rest api - shouw return a Exception ', () async {
    BaseOptions options =
        BaseOptions(baseUrl: "https://jsonplaceholder.typicode.com/g");
    Dio dio = Dio(options);
    RestException exception;

    try {
      var dataClient = DioDataClient(dio);
      await dataClient.read("posts/1");
    } on RestException catch (error) {
      exception = error;
    }

    expect(exception, isNotNull);
    expect(exception, isA<RestException>());
  });
}
