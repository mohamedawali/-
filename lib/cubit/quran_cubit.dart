import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran/repository/quranRepo.dart';

part 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranRepository? quranRepository;
  QuranCubit(this.quranRepository) : super(QuranInitial());
  Future getAllSurah(int id) async {
    List<String>? surahList;
    await quranRepository!.getAllSurah(id).then((value) {
      surahList = value;
    });
    return surahList;
  }
}
