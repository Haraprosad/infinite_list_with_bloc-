import 'package:flutter_infinite_list/posts/models/post.dart';
import 'package:flutter_infinite_list/posts/repositories/post_remote_repository.dart';
import 'package:injectable/injectable.dart';
import '../../di/config_inject.dart';
import '../data/post_remote_datasource.dart';
import 'package:get/get.dart';

@LazySingleton(as: PostRepository)
class PostRepositoryImpl implements PostRepository{
  // final PostRemoteDatasource _remoteSource =
  // Get.find(tag: (PostRemoteDatasource).toString());

  final _remoteSource = getIt<PostRemoteDatasource>();


  @override
  Future<List<Post>> getPosts({int startIndex = 0}) {
    return _remoteSource.getPosts(startIndex: startIndex);
  }

}