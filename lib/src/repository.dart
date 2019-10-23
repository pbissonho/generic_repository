import 'package:dartz/dartz.dart';
import 'data_client.dart';
import 'model.dart';
import 'core/error/exceptions.dart';
import 'core/error/failures.dart';

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

abstract class IReadRepository<T> {
  Future<Either<Failure, T>> getById(int id);

  Future<Either<Failure, List<T>>> getAll();

  Future<Either<Failure, List<T>>> search(IQueryParams queryParameters);
}

abstract class IWriteRepository<T> {
  Future<Either<Failure, Operation>> insert(T model);

  Future<Either<Failure, Operation>> update(T model, int id);

  Future<Either<Failure, Operation>> delete(int id);
}

abstract class IRepository<T extends Model> extends IReadRepository<T>
    with IWriteRepository<T> {}

abstract class ReadOnyRepository<T> implements IReadRepository<T> {
  IDataClient dataClient;
  String get path;
  T fromMap(dynamic map);

  ReadOnyRepository(IDataClient dataClient) {
    this.dataClient = dataClient;
  }

  Future<Either<Failure, T>> getById(int id) async {
    try {
      var data = await dataClient.get(
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
      List<Map<String, dynamic>> data = await dataClient.getListMap(path);

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
          await dataClient.getListMap(path, queryParameters: queryParameters);
      var list = mapToListModel(data);
      return Right(list);
    } on RestException catch (error) {
      return Left(RestFailure(error.message));
    }
  }
}

mixin WriteOny<T extends Model> implements IWriteRepository<T> {
  IDataClient dataClient;
  String get path;

  Future<Either<Failure, Operation>> insert(T model) async {
    try {
      var data = await dataClient.post(path, data: model.toJson());
      return Right(Created(data));
    } on RestException catch (error) {
      return Left(RestFailure(error.message));
    }
  }

  Future<Either<Failure, Operation>> update(T model, int id) async {
    try {
      var data = await dataClient.put("$path/$id", data: model.toJson());
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

abstract class Repository<T extends Model> extends ReadOnyRepository<T>
    with WriteOny<T> {
  Repository(IDataClient dataClient) : super(dataClient);
}

abstract class WriteOnyRepository<T extends Model> with WriteOny<T> {
  IDataClient dataClient;
  WriteOnyRepository(this.dataClient);
}
