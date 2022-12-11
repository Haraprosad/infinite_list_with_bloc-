import '../models/post.dart';

abstract class PostRemoteDatasource{
  Future<List<Post>> getPosts({int startIndex = 0});
}