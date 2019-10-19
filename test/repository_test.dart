import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:generic_repository/src/data_client.dart';
import 'package:generic_repository/src/dio_data_client.dart';
import 'package:generic_repository/src/repository.dart';

import 'classes.dart';

class PostRepository extends Repository<Post> {
  PostRepository(IDataClient dataClient) : super(dataClient);

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

  DioDataClient cliente = DioDataClient(dio);
  test("get all data - shoud return a list of data", () async {
    PostRepository service = new PostRepository(cliente);

    var either = await service.getAll();
    List<Post> posts;
    either.fold((failure) {}, (newPosts) {
      posts = newPosts;
    });

    expect(posts, isNotNull);
    expect(posts, isA<List<Post>>());
  });

  test("getById - shoud return a model ", () async {
    PostRepository service = new PostRepository(cliente);

    var either = await service.getById(1);
    Post post;
    either.fold((failure) {}, (newPost) {
      post = newPost;
    });

    expect(post, isNotNull);
    expect(post, isA<Post>());
    expect(post.id, 1);
  });

  test("Insert a model", () async {
    PostRepository service = new PostRepository(cliente);

    var either = await service.insert(new Post(
      body: "dsfdfs",
      userId: 2,
      title: "Jubile",
    ));

    Operation operation =
        either.fold<Created>((failure) {}, (operation) => Created());

    expect(operation, isNotNull);
    expect(operation, isA<Created>());
  });

  test("Update a model", () async {
    PostWriteOnlyService service = new PostWriteOnlyService(cliente);

    var either = await service.update(
        new Post(
          body: "dsd",
          userId: 2,
          title: "XXXX",
        ),
        2);

    Operation operation = either.getOrElse(() => null);
    expect(operation, isNotNull);
    expect(operation, isA<Updated>());
  });

  test("Delete a model", () async {
    PostRepository service = new PostRepository(cliente);

    var either = await service.delete(1);

    Operation operation = either.getOrElse(() => null);
    expect(operation, isNotNull);
    expect(operation, isA<Deleted>());
  });
}
