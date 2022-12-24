import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/model/argument.dart';
import 'package:quran/cubit/quran_cubit.dart';
import 'package:quran/repository/quranRepo.dart';
import 'package:quran/view/all%20surah.dart';

import 'package:quran/view/home.dart';
import 'package:quran/webService/webService.dart';

class AppNavigator {
  QuranRepository? _quranRepository;
  QuranCubit? _quranCubit;

  AppNavigator() {
    _quranRepository = QuranRepository(WebService());
    _quranCubit = QuranCubit(_quranRepository);
  }

  Route? route(RouteSettings routeSettings) {
    switch (routeSettings.name) {

      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<QuranCubit>.value(
                  value: _quranCubit!,
                  child: Home(),
                ));

      case '/allSurah':
        final idArgument = routeSettings.arguments as ScreenArgument;

        return MaterialPageRoute(
            builder: (BuildContext context) => AllSurah(
                  argument: idArgument,
                ));
    }
  }
}
