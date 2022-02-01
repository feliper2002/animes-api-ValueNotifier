import 'models/anime_model.dart';

abstract class PostState {}

class InitialPostState extends PostState {}

class LoadingPostState extends PostState {
  final bool loadingStatus;

  LoadingPostState(this.loadingStatus);
}

class SuccessPostState extends PostState {
  final List<AnimePost> posts;

  SuccessPostState(this.posts);
}

class ErrorPostState extends PostState {
  final String message;

  ErrorPostState(this.message);
}
