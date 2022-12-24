import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:quran/route/route.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await JustAudioBackground.init(preloadArtwork: true,
androidNotificationIcon: 'mipmap/appicon',
androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
androidNotificationChannelName: 'Audio playback',
androidNotificationOngoing: true

);

runApp( MyApp(appNavigator: AppNavigator()));
}


class MyApp extends StatelessWidget {
  AppNavigator? appNavigator;
   MyApp({Key? key,required this.appNavigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) =>
 MaterialApp(
debugShowCheckedModeBanner: false,
onGenerateRoute:appNavigator!.route,
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.teal,
        ),

      ),
    );
  }
}
