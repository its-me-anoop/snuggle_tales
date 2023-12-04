part of 'story_bloc.dart';

abstract class StoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StoryCreateEvent extends StoryEvent {
  final String storyType;
  final String characters;

  StoryCreateEvent(this.storyType, this.characters);

  @override
  List<Object> get props => [storyType, characters];
}

class FetchStoriesEvent extends StoryEvent {}
