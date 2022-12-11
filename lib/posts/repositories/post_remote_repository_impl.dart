import 'package:flutter_infinite_list/posts/models/post.dart';
import 'package:flutter_infinite_list/posts/repositories/post_remote_repository.dart';
import '../data/post_remote_datasource.dart';
import 'package:get/get.dart';

class PostRepositoryImpl implements PostRepository{
  final PostRemoteDatasource _remoteSource =
  Get.find(tag: (PostRemoteDatasource).toString());


  @override
  Future<List<Post>> getPosts({int startIndex = 0}) {
    return _remoteSource.getPosts(startIndex: startIndex);
  }

}