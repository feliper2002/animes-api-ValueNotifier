// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intoxianimes_value_notifier/modules/home/post_state.dart';
import 'package:intoxianimes_value_notifier/modules/home/presenter/controllers/anime_controller.dart';
import 'package:intoxianimes_value_notifier/modules/home/presenter/view/widgets/loader.dart';

import 'widgets/post_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();

  final controller = Modular.get<AnimeController>();

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  _onScroll() {
    if (_isBottom) controller.getPosts();
  }

  @override
  void initState() {
    super.initState();
    controller.getInitialPosts();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Anime Posts - API'),
          backgroundColor: Colors.black),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: ValueListenableBuilder<PostState>(
          valueListenable: controller,
          builder: (context, value, child) {
            if (value is SuccessPostState) {
              return ListView.builder(
                controller: scrollController,
                itemCount: value.posts.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, index) {
                  final post = value.posts[index];
                  return PostContainer(
                    post: post,
                  );
                },
              );
            }
            if (value is LoadingPostState) {
              if (value.loadingStatus) {
                return const Loader();
              }
            }
            if (value is ErrorPostState) {
              return Center(
                child: Text(value.message),
              );
            }
            return const Loader();
          },
        ),
      ),
    );
  }
}
