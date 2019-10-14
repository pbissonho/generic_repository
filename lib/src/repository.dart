import 'data_client.dart';
import 'model.dart';

abstract class IRead<T> {
  Future<T> getById(int id);

  Future<List<T>> getAll();

  Future<List<T>> filter(Arguments arguments);
}

abstract class IWrite<T> {
  Future<void> insert(T model);

  Future<void> update(T model, int id);

  Future<void> delete(int id);
}

abstract class IRepository<T extends Model> extends IRead<T> with IWrite<T> {}

abstract class ReadOnyRepository<T> implements IRead<T> {
  IDataClient dataClient;
  String get path;
  T fromMap(dynamic map);

  ReadOnyRepository(IDataClient dataClient) {
    this.dataClient = dataClient;
  }

  Future<T> getById(int id) async {
    var data = await dataClient.get(
      "$path/$id",
    );

    return fromMap(data);
  }

  Future<List<T>> getAll() async {
    var data = await dataClient.getListMap(path);
    return converteListMapToListModel(data);
  }

  Future<List<T>> converteListMapToListModel(
      List<Map<String, dynamic>> data) async {
    List<T> models = data.map((data) => fromMap(data)).toList();
    return models;
  }

  Future<List<T>> filter(Arguments arguments) async {
    var data = await dataClient.getListMap(path, arguments: arguments);
    return converteListMapToListModel(data);
  }
}

mixin WriteOny<T extends Model> implements IWrite<T> {
  IDataClient dataClient;
  String get path;

  Future<void> insert(T model) async {
    await dataClient.post(path, data: model.toJson());
  }

  Future<void> update(T model, int id) async {
    await dataClient.put("$path/$id", data: model.toJson());
  }

  Future<void> delete(int id) async {
    await dataClient.delete(
      "$path/$id",
    );
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
