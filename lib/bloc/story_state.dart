part of 'story_bloc.dart';

abstract class StoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class StoryInitialState extends StoryState {}

class StoryLoadingState extends StoryState {}

class StoryLoadedState extends StoryState {
  final String storyContent;
  final String imageUrl;
  final String genre;

  StoryLoadedState(this.storyContent, this.imageUrl, this.genre);

  @override
  List<Object> get props => [storyContent, imageUrl, genre];
}

class StoriesLoadedState extends StoryState {
  final List<DocumentSnapshot> stories;
  final List<DocumentSnapshot> genres;

  StoriesLoadedState(this.stories, this.genres);

  @override
  List<Object> get props => [stories, genres];
}

class StoryErrorState extends StoryState {}
