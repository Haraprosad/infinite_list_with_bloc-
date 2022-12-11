import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_infinite_list/app/core/base/base_remote_source.dart';
import 'package:flutter_infinite_list/core/app_values.dart';
import 'package:flutter_infinite_list/posts/data/post_remote_datasource.dart';
import 'package:injectable/injectable.dart';

import '../../app/network/dio_provider.dart';
import '../models/post.dart';
import 'package:http/http.dart' as http;

@LazySingleton(as: PostRemoteDatasource)
class PostRemoteDatasourceImpl extends BaseRemoteSource implements PostRemoteDatasource{
  final http.Client httpClient = http.Client();

  @override
  Future<List<Post>> getPosts({int startIndex = 0}) async{
    var endpoint = "${DioProvider.baseUrl}/posts";
    var dioClient = dioBasicClient;

    // final response = await httpClient.get(
    //   Uri.https(
    //     'jsonplaceholder.typicode.com',
    //     '/posts',
    //     <String, String>{'_start': '$startIndex', '_limit': '${AppValues.defaultPageSize}'},
    //   ),
    // );

    var dioCall = dioClient.get(endpoint,queryParameters: <String, String>{'_start': '$startIndex', '_limit': '${AppValues.defaultPageSize}'},options: Options(
      responseType: ResponseType.json
    ));
    try{
      // final body = json.decode(dioCall.data) as List;
      // return body.map((dynamic json) {
      //   final map = json as Map<String, dynamic>;
      //   return Post(
      //     id: map['id'] as int,
      //     title: map['title'] as String,
      //     body: map['body'] as String,
      //   );
      // }).toList();
      //return _parsePostResponse(dioCall);
      return callApiWithErrorParser(dioCall).then((response) => _parsePostResponse(response));
    }catch (e){
      rethrow;
    }
  }

  // parse posts response
  List<Post> _parsePostResponse(Response response) {
    // final body = json.decode(response.data) as List;
    // return body.map((dynamic json) {
    //   final map = json as Map<String, dynamic>;
    //   return Post(
    //     id: map['id'] as int,
    //     title: map['title'] as String,
    //     body: map['body'] as String,
    //   );
    // }).toList();
    return postFromJson(response.data);
  }
}