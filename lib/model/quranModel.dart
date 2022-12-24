class QuranModel {
  List<Reciters>? reciters;
  QuranModel({this.reciters});
  QuranModel.fromJson(Map<String, dynamic> json) {
    if (json['reciters'] != null) {
      reciters = <Reciters>[];
      json['reciters'].forEach((v) {
        reciters!.add(new Reciters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reciters != null) {
      data['reciters'] = this.reciters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reciters {
  int? id;
  String? name;
  String? letter;
  List<Moshaf>? moshaf;

  Reciters({this.id, this.name, this.letter, this.moshaf});

  Reciters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    letter = json['letter'];
    if (json['moshaf'] != null) {
      moshaf = <Moshaf>[];
      json['moshaf'].forEach((v) {
        moshaf!.add(new Moshaf.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['letter'] = this.letter;
    if (this.moshaf != null) {
      data['moshaf'] = this.moshaf!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Moshaf {
  int? id;
  String? name;
  String? server;
  int? surahTotal;
  String? surahList;

  Moshaf({this.id, this.name, this.server, this.surahTotal, this.surahList});

  Moshaf.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    server = json['server'];
    surahTotal = json['surah_total'];
    surahList = json['surah_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['server'] = this.server;
    data['surah_total'] = this.surahTotal;
    data['surah_list'] = this.surahList;
    return data;
  }
}
