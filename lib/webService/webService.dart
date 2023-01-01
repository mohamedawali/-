import 'package:dio/dio.dart';
import 'package:quran/constants/strings.dart';
import 'package:quran/model/quranModel.dart';

class WebService {
  List<Moshaf>? _moshaf;
  var _moshafServer, _stringSurahList, _surahList;

  Dio? _dio;

  WebService() {
    BaseOptions options = BaseOptions(baseUrl: basicUrl);
    _dio = Dio(options);
  }

  Future<List<String>> getAllSurah(int id) async {
    List<String> allSurahList = [];
    try {
      var response = await _dio!
          .get('reciters', queryParameters: {'language': 'ar', 'reciter': id});
      var quranModelReciters = QuranModel.fromJson(response.data).reciters;

      quranModelReciters!.forEach((e) {
        _moshaf = e.moshaf;
      });
      _moshafServer = _moshaf![0].server;

      _stringSurahList = _moshaf![0].surahList;

      _surahList = _stringSurahList!.split(',');

      for (int i = 0; i < _surahList.length; i++) {
        if (_surahList[i].length < 2) {
          allSurahList.add('${_moshafServer}00${_surahList[i]}.mp3');
        } else if (_surahList[i].length == 2) {
          allSurahList.add('${_moshafServer}0${_surahList[i]}.mp3');
        } else if (_surahList[i].length > 2) {
          allSurahList.add('${_moshafServer}${_surahList[i]}.mp3');
        }
      }
      return allSurahList.toList();
    } on Exception catch(e) {
      return allSurahList.toList();    }


  }
}
