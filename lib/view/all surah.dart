import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'dart:core';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:quran/model/argument.dart';
import 'package:quran/constants/strings.dart';
import 'package:quran/model/durationState.dart';
import 'package:quran/widget/play_pause.dart';
import 'package:quran/widget/shuffle_button.dart';
import 'package:rxdart/rxdart.dart';

class AllSurah extends StatefulWidget {
  ScreenArgument? argument;
  AllSurah({Key? key, this.argument}) : super(key: key);

  @override
  State<AllSurah> createState() => _AllSurahState(argument!);
}

class _AllSurahState extends State<AllSurah> {
  ScreenArgument? _screenArgument;
  String _suraName = 'لا توجد تلاوة';
  AudioPlayer? _audioPlayer;
  int? _nextIndex, _previousIndex;
  ConnectivityResult? _connectivityResult;
  final List<UriAudioSource> _uriAudioSourceList = [];
  ConcatenatingAudioSource? _concatenatingAudioSource;
  _AllSurahState(ScreenArgument arg) {
    _screenArgument = arg;
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();


    Connectivity().onConnectivityChanged.listen((result) {

      setState(() {
        _connectivityResult = result;
        checkInternet();
      });

    });
    allQuran(_screenArgument!.surahList, _screenArgument!.name);

  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('asset/background.png'),
                  fit: BoxFit.cover,
                  opacity: 0.2)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: screenSize.height*0.62 ,
            child:
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const PageScrollPhysics(),
                      separatorBuilder: (context, index) => const Divider(
                            thickness: 1,
                          ),
                      itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(
                              right: 10, top: 5, bottom: 5, left: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              StreamBuilder<PlayerState>(
                                  stream: _audioPlayer!.playerStateStream,
                                  builder: (context, snapshot) {
                                    return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _suraName = surahName[index];
                                          });

                                        play(index);
                                        },
                                        child: Text(
                                          surahName[index],
                                          style: TextStyle(fontSize: 20.sp),
                                        ));
                                  }),
                              SizedBox(
                                width: 10.w,
                              ),
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                  _screenArgument!.image!,
                                ),
                                radius: 30.r,
                              ),
                            ],
                          )),
                      itemCount: _screenArgument!.surahList.length)

                  // }
                  ),
              Container(
               // width: screenSize.width,
                height: screenSize.height *0.26,
                decoration: const BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10,right: 10,left: 10,bottom: 20),
                  child: Column(
                    children: [
                      // Padding(
                      //     padding: const EdgeInsets.only(top: 5),
                      //     child:
                          Text(
                            '﴾$_suraName﴿',
                            style: TextStyle(fontSize: 18.sp,color: Colors.white),
                         // )
                ),
                      StreamBuilder<DurationState>(
                          builder: (context, snapshot) {
                            final d = snapshot.data;
                            return ProgressBar(baseBarColor: Colors.teal[900],thumbColor: Colors.white,progressBarColor: Colors.white,
                              progress: d?.position ?? Duration.zero ,
                              buffered: d?.bufferedPosition ?? Duration.zero,
                              total: d?.duration ?? Duration.zero,
                              timeLabelLocation: TimeLabelLocation.sides,
                              onSeek: (duration) {
                                seekToSec(duration);
                              },
                            );
                          },
                          stream: _positionDataStream),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                StreamBuilder<bool>(
                                    stream:
                                        _audioPlayer!.shuffleModeEnabledStream,
                                    builder: (context, snapshot) {
                                      return shuffleButton(
                                          snapshot, _audioPlayer!);
                                    }),
                              ],
                            ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(backgroundColor: Colors.white,
                              radius: 20,
                              child: StreamBuilder<SequenceState?>(
                                  stream: _audioPlayer!.sequenceStateStream,
                                  builder: (context, snapshot) {
                                    return IconButton(
                                        onPressed: ()  {
                                          seekToPrevious();

                                        },
                                        icon: const Icon(Icons.skip_previous));
                                  })),
                          CircleAvatar(backgroundColor: Colors.white,
                              radius: 20,
                              child: StreamBuilder<PlayerState>(
                                  stream: _audioPlayer!.playerStateStream,
                                  builder: (_, snapshot) {
                                    if (snapshot.hasData) {
                                      return playPause(snapshot, _audioPlayer!);
                                    } else {
                                      return const SizedBox();
                                    }
                                  })),
                          CircleAvatar(backgroundColor: Colors.white,
                              radius: 20,
                              child: StreamBuilder<SequenceState?>(
                                  stream: _audioPlayer!.sequenceStateStream,
                                  builder: (context, snapshot) {
                                    return IconButton(
                                        onPressed: () async {
                                          seekToNext();

                                        },
                                        icon: const Icon(Icons.skip_next));
                                  }))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
       )
    );
  }

  Future<void> play(int index) async {

    await _audioPlayer!.setAudioSource(_concatenatingAudioSource!,
        initialIndex: index, initialPosition: Duration.zero);

    await _audioPlayer!.play();
  }

  void allQuran(List surahList, String? name) async {
    int i = 0;

    for (i; i < surahList.length; i++) {
      _uriAudioSourceList.add(AudioSource.uri(Uri.parse(surahList[i]),
          tag: MediaItem(
              id: '$i',
              title: '$name',
              album: surahName[i],

          )));
    }
    _concatenatingAudioSource = ConcatenatingAudioSource(
        children: _uriAudioSourceList,
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder());
  }

  Future<void> checkInternet() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      await _audioPlayer!.play();
    } else {
      await _audioPlayer!.pause();
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text(
                  '! حدث خطأ',
                  textAlign: TextAlign.end,
                ),
                content: Text(
                  'لايوجداتصال بالانترنت',
                  textAlign: TextAlign.end,
                ),
              ));
    }
    setState(() {
      _connectivityResult = connectivityResult;
    });
  }

  void seekToSec(Duration duration) {
    _audioPlayer!.seek(duration);
  }

  Stream<DurationState> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, DurationState>(
          _audioPlayer!.positionStream,
          _audioPlayer!.bufferedPositionStream,
          _audioPlayer!.durationStream,
          (position, bufferedPosition, duration) => DurationState(
              position, bufferedPosition, duration ?? Duration.zero));


  Future<void> seekToPrevious() async {
    _previousIndex = _audioPlayer!.previousIndex!;
    checkInternet();
    await _audioPlayer!.seekToPrevious();
    setState(() {
      _suraName = surahName[_previousIndex!];
    });
  }

 Future <void> seekToNext() async{
    _nextIndex = _audioPlayer!.nextIndex!;
    checkInternet();
    await _audioPlayer!.seekToNext();
    setState(() {
    _suraName = surahName[_nextIndex!];
    });
  }

  @override
  void dispose() {
    _audioPlayer!.dispose();
    super.dispose();
  }

}
