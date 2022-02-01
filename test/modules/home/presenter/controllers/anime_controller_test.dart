import 'package:flutter_test/flutter_test.dart';
import 'package:intoxianimes_value_notifier/modules/home/models/anime_model.dart';
import 'package:intoxianimes_value_notifier/modules/home/post_state.dart';
import 'package:intoxianimes_value_notifier/modules/home/presenter/controllers/anime_controller.dart';
import 'package:intoxianimes_value_notifier/modules/home/repository/anime_repository.dart';
import 'package:intoxianimes_value_notifier/modules/home/usecases/get_initial_posts.dart';
import 'package:intoxianimes_value_notifier/modules/home/usecases/get_posts.dart';
import 'package:mocktail/mocktail.dart';

class AnimeRepositoryMock extends Mock implements AnimeRepository {}

void main() {
  final repository = AnimeRepositoryMock();
  final getInitialPosts = GetInitialPostsImpl(repository);
  final getPosts = GetPostsImpl(repository);
  final controller = AnimeController(getInitialPosts, getPosts);
  test('Should return an SuccessPostState.', () async {
    when(() => repository.getAnimePost())
        .thenAnswer((_) async => <AnimePost>[]);

    await controller.getInitialPosts();

    expect(controller.value, isA<SuccessPostState>());
  });

  test('Should return an SuccessPostState on page change.', () async {
    when(() => repository.getAnimePost(page: 2))
        .thenAnswer((_) async => <AnimePost>[]);

    await controller.getPosts();

    expect(controller.value, isA<SuccessPostState>());
  });
}
