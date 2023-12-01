import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:snuggle_tales/Services/story_service.dart'; // Import your services

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StoryBloc() : super(StoryInitialState()) {
    on<StoryCreateEvent>(_onCreateStory);
  }

  void _onCreateStory(StoryCreateEvent event, Emitter<StoryState> emit) async {
    emit(StoryLoadingState());
    try {
      String compiledMessage =
          "Age ${event.age.toInt()} years using ${event.characters}";
      String imageQuery = '${event.characters} ${event.storyType}';

      String response = await getChatGPTResponse(compiledMessage);
      String imageResponse = await getImageResponse(imageQuery);

      // Save story to Firestore
      await firestore.collection('stories').add({
        'age': event.age,
        'storyType': event.storyType,
        'characters': event.characters,
        'storyContent': response,
        'imageUrl': imageResponse,
        'createdAt': FieldValue.serverTimestamp(), // optional: timestamp
      });

      emit(StoryLoadedState(response, imageResponse));
    } catch (e) {
      emit(StoryErrorState());
    }
  }
}
