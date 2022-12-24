import 'package:quran/webService/webService.dart';

class QuranRepository{
  WebService? webService;

  QuranRepository(this.webService);
  Future<List<String>> getAllSurah(int id) async {

return  await webService!.getAllSurah(id);


}}
