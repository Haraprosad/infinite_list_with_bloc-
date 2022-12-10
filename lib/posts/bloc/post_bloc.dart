import 'dart:async';
import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/posts/bloc/post_events.dart';
import 'package:flutter_infinite_list/posts/bloc/post_state.dart';
import 'package:flutter_infinite_list/posts/models/post.dart';
import 'package:http/http.dart' as http;

import 'package:stream_transform/stream_transform.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

const _postLimit = 20;


class PostBloc extends Bloc<PostEvent,PostState>{
  PostBloc({required this.httpClient}):super(const PostState()){
    on<PostFetched>(_onPostFetched,
    transformer: throttleDroppable(throttleDuration));
  }

  final http.Client httpClient;

  Future<void> _onPostFetched(PostFetched event, Emitter<PostState> emit) async{
    if(state.hasReachedMax) return;

    try{
      if(state.status == PostStatus.initial){
        final posts = await _fetchPosts();
        return emit(state.copyWith(status: PostStatus.success,
        posts: posts,
        hasReachedMax: false));
      }

      final posts= await _fetchPosts(state.posts.length);
      emit(posts.isEmpty?state.copyWith(hasReachedMax: true):
        state.copyWith(status: PostStatus.success,
        posts: List.of(state.posts)..addAll(posts),
        hasReachedMax: false),
      );
    }catch(_){
      emit(state.copyWith(status: PostStatus.failure));
    }
  }


  //fetching data
  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Post(
          id: map['id'] as int,
          title: map['title'] as String,
          body: map['body'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}