part of 'story_bloc.dart';

abstract class StoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StoryCreateEvent extends StoryEvent {
  final String characters;

  StoryCreateEvent(this.characters);

  @override
  List<Object> get props => [characters];
}

class FetchStoriesEvent extends StoryEvent {}
