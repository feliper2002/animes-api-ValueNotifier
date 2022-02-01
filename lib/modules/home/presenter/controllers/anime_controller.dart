import 'package:flutter/cupertino.dart';
import 'package:intoxianimes_value_notifier/modules/home/models/anime_model.dart';
import 'package:intoxianimes_value_notifier/modules/home/usecases/get_initial_posts.dart';
import 'package:intoxianimes_value_notifier/modules/home/usecases/get_posts.dart';
import 'package:intoxianimes_value_notifier/utils/failure.dart';

import '../../post_state.dart';

// ignore: must_be_immutable
class AnimeController extends ValueNotifier<PostState> {
  AnimeController(this._getInitialPostsUsecase, this._getPostsUsecase)
      : super(InitialPostState());

  final GetInitialPosts _getInitialPostsUsecase;
  final GetPosts _getPostsUsecase;

  List<AnimePost> posts = [];

  Future<void> getInitialPosts() async {
    final usecase = await _getInitialPostsUsecase();
    value = LoadingPostState(true);

    usecase.fold(
      (error) {
        if (error is ForbiddenFailure) {
          value = ErrorPostState(
              "Não foi possível carregar os posts iniciais. - ${error.message}");
        }
        value = LoadingPostState(false);
      },
      (listaDePosts) {
        posts = listaDePosts;
        value = SuccessPostState(posts);
      },
    );
  }

  int _page = 1;
  _incrementPage() => _page++;

  Future<void> getPosts() async {
    if (_page < 200) _incrementPage();
    final usecase = await _getPostsUsecase(page: _page);

    usecase.fold(
      (error) {
        if (error is ForbiddenFailure) {
          value = ErrorPostState(
              "Não foi possível carregar os posts iniciais. - ${error.message}");
        }
      },
      (novosPosts) {
        posts.addAll(novosPosts);
        value = SuccessPostState(posts);
      },
    );
  }
}
