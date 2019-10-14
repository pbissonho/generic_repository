import 'package:generic_repository/src/data_client.dart';
import 'package:generic_repository/src/repository.dart';

import '../models/post.dart';

class PostRepository extends Repository<Post> {
  PostRepository(IDataClient dataClient) : super(dataClient);

  @override
  fromMap(map) => Post.fromJson(map);
  String get path => "posts";
}
