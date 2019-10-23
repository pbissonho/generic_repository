import 'dart:async';
import 'package:generic_repository/src/dio_data_client.dart';
import 'package:generic_repository/src/model.dart';
import 'package:generic_repository/src/repository.dart';

class Post implements Model {
  int userId;
  int id;
  String title;
  String body;

  Post({this.userId, this.id, this.title, this.body});

  Post.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}

abstract class IPostRepository implements IRepository<Post, int> {}

class PostRepository extends Repository<Post, int> implements IPostRepository {
  PostRepository(DioDataClient client) : super(client);

  @override
  Post fromMap(map) => Post.fromJson(map);

  @override
  String get path => "posts";
}

class PostBloc {
  IPostRepository _postRepositort;
  StreamController _controller = StreamController<List<Post>>();

  void getPosts() async {
    var result = await _postRepositort.getAll();
    result.fold((failure) {
      _controller.addError(failure.message);
    }, (posts) {
      _controller.add(posts);
    });
  }

  void dispose() {
    _controller.close();
  }
}
