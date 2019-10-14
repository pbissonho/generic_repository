import 'package:generic_repository/src/data_client.dart';
import 'package:generic_repository/src/repository.dart';
import '../models/comment.dart';

class CommentRepository extends ReadOnyRepository<Comment> {
  CommentRepository(IDataClient dataClient) : super(dataClient);

  fromMap(map) => Comment.fromJson(map);

  String get path => "comments";
}
