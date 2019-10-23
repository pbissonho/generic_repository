import 'package:dartz/dartz.dart';
import 'data_client.dart';
import 'core/error/exceptions.dart';
import 'core/error/failures.dart';
import 'interfaces/model.dart';
import 'interfaces/query_params.dart';

class Operation {
  final Map<String, dynamic> dataResult;

  Operation(this.dataResult);
}

class Created extends Operation {
  Created(Map<String, dynamic> dataResult) : super(dataResult);
}

class Updated extends Operation {
  Updated(Map<String, dynamic> dataResult) : super(dataResult);
}

class Deleted extends Operation {
  Deleted(Map<String, dynamic> dataResult) : super(dataResult);
}

abstract class IReadRepository<T, Id> {
  Future<Either<Failure, T>> getById(Id id);

  Future<Either<Failure, List<T>>> getAll();

  Future<Either<Failure, List<T>>> search(IQueryParams queryParameters);
}

abstract class IWriteRepository<T, Id> {
  Future<Either<Failure, Operation>> insert(T model);

  Future<Either<Failure, Operation>> update(T model, Id id);

  Future<Either<Failure, Operation>> delete(int id);
}

abstract class IRepository<T extends IModel, Id> extends IReadRepository<T, Id>
    with IWriteRepository<T, Id> {}

abstract class ReadOnyRepository<T, Id> implements IReadRepository<T, Id> {
  IDataClient dataClient;
  String get path;
  T fromMap(dynamic map);

  ReadOnyRepository(IDataClient dataClient) {
    this.dataClient = dataClient;
  }

  Future<Either<Failure, T>> getById(Id id) async {
    try {
      var data = await dataClient.read(
        "$path/$id",
      );
      T model = fromMap(data);
      return Right(model);
    } on RestException catch (error) {
      return Left(RestFailure(error.message));
    }
  }

  Future<Either<Failure, List<T>>> getAll() async {
    try {
      List<Map<String, dynamic>> data = await dataClient.readMany(path);

      if (data is List<Map<String, dynamic>>) {
        var list = mapToListModel(data);
        return Right(list);
      } else {
        return Left(RestFailure("Data not is a List<Map<String, dynamic>>"));
      }
    } on RestException catch (error) {
      return Left(RestFailure(error.message));
    }
  }

  List<T> mapToListModel(List<Map<String, dynamic>> data) {
    List<T> models = data.map((data) => fromMap(data)).toList();
    return models;
  }

  Future<Either<Failure, List<T>>> search(IQueryParams queryParameters) async {
    try {
      var data =
          await dataClient.readMany(path, queryParameters: queryParameters);
      var list = mapToListModel(data);
      return Right(list);
    } on RestException catch (error) {
      return Left(RestFailure(error.message));
    }
  }
}

mixin WriteOny<T extends IModel, Id> implements IWriteRepository<T, Id> {
  IDataClient dataClient;
  String get path;

  Future<Either<Failure, Operation>> insert(T model) async {
    try {
      var data = await dataClient.create(path, data: model.toJson());
      return Right(Created(data));
    } on RestException catch (error) {
      return Left(RestFailure(error.message));
    }
  }

  Future<Either<Failure, Operation>> update(T model, Id id) async {
    try {
      var data = await dataClient.update("$path/$id", data: model.toJson());
      return Right(Updated(data));
    } on RestException catch (error) {
      return Left(RestFailure(error.message));
    }
  }

  Future<Either<Failure, Operation>> delete(int id) async {
    try {
      var data = await dataClient.delete(
        "$path/$id",
      );
      return Right(Deleted(data));
    } on RestException catch (error) {
      return Left(RestFailure(error.message));
    }
  }
}

abstract class Repository<T extends IModel, Id> extends ReadOnyRepository<T, Id>
    with WriteOny<T, Id> {
  Repository(IDataClient dataClient) : super(dataClient);
}

abstract class WriteOnyRepository<T extends IModel, Id> with WriteOny<T, Id> {
  IDataClient dataClient;
  WriteOnyRepository(this.dataClient);
}
