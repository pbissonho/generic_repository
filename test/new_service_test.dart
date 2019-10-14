import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:generic_repository/src/data_client.dart';
import 'package:generic_repository/src/dio_data_client.dart';
import 'package:generic_repository/src/repository.dart';

import 'classes.dart';

class PostService extends Repository<Post> {
  PostService(IDataClient dataClient) : super(dataClient);

  @override
  fromMap(map) => Post.fromJson(map);

  String get path => "posts";
}

class PostReadOnyService extends ReadOnyRepository<Post> {
  PostReadOnyService(IDataClient dataClient) : super(dataClient);

  @override
  fromMap(map) => Post.fromJson(map);

  String get path => "posts";
}

class PostWriteOnlyService extends WriteOnyRepository<Post> {
  PostWriteOnlyService(IDataClient dataClient) : super(dataClient);
  String get path => "posts";
}

void main() async {
  BaseOptions options =
      BaseOptions(baseUrl: "https://jsonplaceholder.typicode.com/");
  Dio dio = Dio(options);

  dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
    print(options.uri);
    return options; //continue
  }, onResponse: (Response response) {
    print(response.statusCode);
    return response; // continue
  }, onError: (DioError e) {
    // Do something with response error
    return e; //continue
  }));

  DioDataClient cliente = DioDataClient(dio);
  test("Test Service Full", () async {
    PostService service = new PostService(cliente);
    List<Post> posts = await service.getAll();
    print(posts.first.id);
  });

  test("Test Service Read Ony", () async {
    PostReadOnyService service = new PostReadOnyService(cliente);
    List<Post> posts = await service.getAll();

    print(posts.first.id);
  });

  test("Test Service Write Ony - Insert", () async {
    PostWriteOnlyService service = new PostWriteOnlyService(cliente);

    service.insert(new Post(
      body: "dsfdfs",
      userId: 2,
      title: "Jubile",
    ));
  });

  test("Test Service Write Update", () async {
    PostWriteOnlyService service = new PostWriteOnlyService(cliente);

    service.update(
        new Post(
          body: "dsfdfs",
          userId: 2,
          title: "Jubile",
        ),
        2);
  });

  test("Test Service Write Delete", () async {
    PostWriteOnlyService service = new PostWriteOnlyService(cliente);

    service.delete(2);
  });
}
