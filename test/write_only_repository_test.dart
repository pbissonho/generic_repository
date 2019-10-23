import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:generic_repository/src/data_client.dart';
import 'package:generic_repository/src/repository.dart';
import 'package:mockito/mockito.dart';

import 'fixtures/classes.dart';
import 'fixtures/fixture_reader.dart';

class MockDioDataClient extends Mock implements IDataClient {}

void main() async {
  IDataClient datacliente;
  PostRepository service;

  setUp(() {
    datacliente = MockDioDataClient();
    service = PostRepository(datacliente);
  });

  var postJson = json.decode(fixture("post.json"));

  test("Insert a model", () async {
    when(datacliente.create(any)).thenAnswer((_) => Future.value());

    var either = await service.insert(Post.fromJson(postJson));

    Operation operation = either.fold<Created>(
        (failure) => null, (operation) => Created({"": ""}));

    expect(operation, isNotNull);
    expect(operation, isA<Created>());
  });

  test("Update a model", () async {
    when(datacliente.update(any)).thenAnswer((_) => Future.value());

    var either = await service.update(Post.fromJson(postJson), 2);

    Operation operation = either.getOrElse(() => null);
    expect(operation, isNotNull);
    expect(operation, isA<Updated>());
  });

  test("Delete a model", () async {
    when(datacliente.delete(any)).thenAnswer((_) => Future.value());

    var either = await service.delete(1);

    Operation operation = either.getOrElse(() => null);
    expect(operation, isNotNull);
    expect(operation, isA<Deleted>());
  });
}
