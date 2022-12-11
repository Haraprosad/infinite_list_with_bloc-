import 'package:dio/dio.dart';
import 'package:flutter_infinite_list/app/core/base/base_remote_source.dart';
import 'package:flutter_infinite_list/core/app_values.dart';
import 'package:flutter_infinite_list/posts/data/post_remote_datasource.dart';

import '../../app/network/dio_provider.dart';
import '../models/post.dart';

class PostRemoteDatasourceImpl extends BaseRemoteSource implements PostRemoteDatasource{
  @override
  Future<List<Post>> getPosts({int startIndex = 0}) async{
    var endpoint = "${DioProvider.baseUrl}/posts";
    var dioClient = dioBasicClient;

    var dioCall = dioClient.get(endpoint,queryParameters: <String, String>{'_start': '$startIndex', '_limit': '${AppValues.defaultPageSize}'});
    try{
      return callApiWithErrorParser(dioCall).then((response) => _parsePostResponse(response));
    }catch (e){
      rethrow;
    }
  }

  // parse posts response
  List<Post> _parsePostResponse(Response<dynamic> response) {
    return postFromJson(response.data);
  }
}