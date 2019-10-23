import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:generic_repository/generic_repository.dart';
import 'package:generic_repository/src/core/error/exceptions.dart';
import 'package:generic_repository/src/data_client.dart';
import 'package:mockito/mockito.dart';

import 'fixtures/classes.dart';
import 'fixtures/fixture_reader.dart';

class MockDioDataClient extends Mock implements IDataClient {}

void main() async {
  IDataClient datacliente;
  PostRepository service;

  var jsonData = fixture("posts.json");
  var listJsonPostsData = json.decode(jsonData);
  Map<String, dynamic> postJson = json.decode(fixture("post.json"));
  var listMap = List<Map<String, dynamic>>.from(listJsonPostsData);

  setUp(() {
    datacliente = MockDioDataClient();
    service = PostRepository(datacliente);
  });

  test("get all data - shoud return a list of data", () async {
    when(datacliente.readMany(any)).thenAnswer((_) => Future.value(listMap));

    var either = await service.getAll();
    List<Post> posts;
    either.fold((failure) {}, (newPosts) {
      posts = newPosts;
    });

    expect(posts, isNotNull);
    expect(posts, isA<List<Post>>());
  });

  test("when get all data return a error - shoud return a RestFailure",
      () async {
    when(datacliente.readMany(any)).thenThrow(RestException("Error"));

    var either = await service.getAll();
    RestFailure failure;

    either.fold((newFailure) {
      failure = newFailure;
    }, (newPosts) {});

    expect(failure, isNotNull);
    expect(failure, isA<RestFailure>());
  });

  test("when get a model by data return a error - shoud return a RestFailure",
      () async {
    when(datacliente.readMany(any)).thenThrow(RestException("Error"));

    var either = await service.getById(1);
    RestFailure failure;

    either.fold((newFailure) {
      failure = newFailure;
    }, (newPosts) {});

    expect(failure, isNotNull);
    expect(failure, isA<RestFailure>());
  });
}
