part of 'story_bloc.dart';

abstract class StoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StoryCreateEvent extends StoryEvent {
  final double age;
  final String storyType;
  final String characters;

  StoryCreateEvent(this.age, this.storyType, this.characters);

  @override
  List<Object> get props => [age, storyType, characters];
}

class FetchStoriesEvent extends StoryEvent {}
