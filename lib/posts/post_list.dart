import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/posts/bloc/post_bloc.dart';
import 'package:flutter_infinite_list/posts/bloc/post_events.dart';
import 'package:flutter_infinite_list/posts/bloc/post_state.dart';
import 'package:flutter_infinite_list/posts/widget/bottom_loader.dart';
import 'package:flutter_infinite_list/posts/widget/post_list_item.dart';

class PostList extends StatefulWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
     _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController..removeListener(_onScroll)..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc,PostState>(builder: (context, state) {
      switch (state.status){
        case PostStatus.failure:
          return const Center(child: Text("Failed to fetch posts."),);
        case PostStatus.success:
          if(state.posts.isEmpty){
            return const Center(child: Text("No Posts"),);
          }
          return ListView.builder(itemBuilder: (BuildContext context, int index){
            return index>= state.posts.length?const BottomLoader():PostListItem(post: state.posts[index]);
          },
            itemCount: state.hasReachedMax?state.posts.length:state.posts.length+1,
            controller: _scrollController,
          );

        case PostStatus.initial:
          return const Center(child: CircularProgressIndicator(),);
      }
    });
  }

  void _onScroll(){
    if(_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom{
    if(!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll>=(maxScroll*0.9);
  }
}
