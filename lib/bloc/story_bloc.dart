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
      String compiledMessage = "using ${event.characters}";

      String response = await getChatGPTResponse(compiledMessage);
      String dalleImageResponse =
          await getImageResponse(response.split('\n\n').first);

      // Decode the base64 image string to bytes
      Uint8List imageData = base64Decode(dalleImageResponse);

      // Upload to Firebase Storage
      String fileName =
          'story_images/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putData(imageData);
      await uploadTask.whenComplete(() async {
        var imageUrl = await ref.getDownloadURL();

        String genre =
            response.split('\n\n')[1].trim(); // Extract genre from response

        // Check if the genre already exists
        QuerySnapshot genreQuery = await firestore
            .collection('genres')
            .where('genre', isEqualTo: genre)
            .limit(1)
            .get();

        // Add genre if it doesn't exist
        if (genreQuery.docs.isEmpty) {
          await firestore.collection('genres').add({'genre': genre});
        }

        // Save story details to Firestore with the new image URL
        await firestore.collection('stories').add({
          'title': response.split('\n\n').first,
          'genre': genre,
          'storyContent': response,
          'imageUrl': imageUrl,
          'createdAt': FieldValue.serverTimestamp(), // optional: timestamp
        });

        emit(StoryLoadedState(response, imageUrl, genre));
      });
    } catch (e) {
      emit(StoryErrorState());
    }
  }

  Future<void> _onFetchStories(
      FetchStoriesEvent event, Emitter<StoryState> emit) async {
    emit(StoryLoadingState());
    try {
      QuerySnapshot stories =
          await FirebaseFirestore.instance.collection('stories').get();
      QuerySnapshot genres =
          await FirebaseFirestore.instance.collection('genres').get();

      emit(StoriesLoadedState(stories.docs, genres.docs));
    } catch (e) {
      emit(StoryErrorState());
    }
  }
}
