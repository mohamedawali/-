import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';





Widget shuffleButton(AsyncSnapshot<bool> snapshot, AudioPlayer audioPlayer) {
 final isState = snapshot.data ?? false;

  return IconButton(
      onPressed: () async {
        final state=!isState;

        if (state ){
          await audioPlayer.shuffle();

        }
        await audioPlayer.setShuffleModeEnabled(state);
      },
      icon: isState ?  const Icon(
              Icons.shuffle,
              color: Colors.white,
            )
          : const Icon(Icons.shuffle,color: Colors.black,));
}

