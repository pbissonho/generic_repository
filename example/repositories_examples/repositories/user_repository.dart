import 'package:generic_repository/src/data_client.dart';
import 'package:generic_repository/src/repository.dart';
import '../models/user.dart';

class UserRepository extends Repository<User> {
  UserRepository(IDataClient dataClient) : super(dataClient);

  @override
  fromMap(map) => User.fromJson(map);

  String get path => "users";
}
