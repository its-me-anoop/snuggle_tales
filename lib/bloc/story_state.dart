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

  StoryLoadedState(this.storyContent, this.imageUrl);

  @override
  List<Object> get props => [storyContent, imageUrl];
}

class StoriesLoadedState extends StoryState {
  final List<DocumentSnapshot> stories;

  StoriesLoadedState(this.stories);

  @override
  List<Object> get props => [stories];
}

class StoryErrorState extends StoryState {}
