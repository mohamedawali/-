import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

Widget playPause(
    AsyncSnapshot<PlayerState>? snapshot, AudioPlayer audioPlayer ) {
  final state = snapshot!.data;
  final processingState = state!.processingState;



  if (audioPlayer.playing != true) {
    return IconButton(
      icon: const Icon(Icons.play_arrow),
      onPressed: () async {
        await audioPlayer.play();
      },
    );
  }
  else if (processingState == ProcessingState.completed) {
    return IconButton(
        icon: const Icon(Icons.play_arrow),
        onPressed: () async {
          await audioPlayer.play();
        });
  }
  else if (processingState == ProcessingState.idle) {
    return IconButton(
        icon: const Icon(Icons.play_arrow),
        onPressed: () async {
          await audioPlayer.play();
        });
  }
  else {
    return IconButton(
        icon: const Icon(Icons.pause),
        onPressed: () async {
          await audioPlayer.pause();
        });}
}
