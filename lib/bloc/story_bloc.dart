import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:snuggle_tales/Services/story_service.dart'; // Import your services
import 'package:firebase_storage/firebase_storage.dart';

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StoryBloc() : super(StoryInitialState()) {
    on<StoryCreateEvent>(_onCreateStory);
    on<FetchStoriesEvent>(_onFetchStories);
  }

  void _onCreateStory(StoryCreateEvent event, Emitter<StoryState> emit) async {
    emit(StoryLoadingState());
    try {
      String compiledMessage =
          "Age ${event.age.toInt()} years using ${event.characters}";
      String imageQuery = '${event.characters} ${event.storyType}';

      String response = await getChatGPTResponse(compiledMessage);
      String dalleImageResponse = await getImageResponse(imageQuery);

      // Decode the base64 image string to bytes
      Uint8List imageData = base64Decode(dalleImageResponse);

      // Upload to Firebase Storage
      String fileName =
          'story_images/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putData(imageData);
      await uploadTask.whenComplete(() async {
        var imageUrl = await ref.getDownloadURL();

        // Save story details to Firestore with the new image URL
        await firestore.collection('stories').add({
          'age': event.age,
          'storyType': event.storyType,
          'characters': event.characters,
          'storyContent': response,
          'imageUrl': imageUrl,
          'createdAt': FieldValue.serverTimestamp(), // optional: timestamp
        });

        emit(StoryLoadedState(response, imageUrl)); // Send the new image URL
      });
    } catch (e) {
      emit(StoryErrorState());
    }
  }

  Future<void> _onFetchStories(
      FetchStoriesEvent event, Emitter<StoryState> emit) async {
    emit(StoryLoadingState());
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('stories').get();
      emit(StoriesLoadedState(snapshot.docs));
    } catch (e) {
      emit(StoryErrorState());
    }
  }
}
