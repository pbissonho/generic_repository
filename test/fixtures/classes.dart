import 'package:generic_repository/generic_repository.dart';

class Post implements IModel {
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

class PostRepository extends Repository<Post, int> {
  PostRepository(IDataClient dataClient) : super(dataClient);

  @override
  fromMap(map) => Post.fromJson(map);

  String get path => "posts";
}

class PostReadOnyService extends ReadOnyRepository<Post, int> {
  PostReadOnyService(IDataClient dataClient) : super(dataClient);

  @override
  fromMap(map) => Post.fromJson(map);

  String get path => "posts";
}

class PostWriteOnlyService extends WriteOnyRepository<Post, int> {
  PostWriteOnlyService(IDataClient dataClient) : super(dataClient);
  String get path => "posts";
}
