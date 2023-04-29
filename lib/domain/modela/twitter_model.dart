class TwitterModel {
  String? id;
  String? twtId;
  String? twtTime;
  String? twtTxt;
  String? twtRetweetCount;
  String? favoriteCount;
  String? twtLang;
  int? hours; // added property

  TwitterModel({
    this.id,
    this.twtId,
    this.twtTime,
    this.twtTxt,
    this.twtRetweetCount,
    this.favoriteCount,
    this.twtLang,
    this.hours, // initialized here
  });

  TwitterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    twtId = json['twt_id'];
    twtTime = json['twt_time'];
    twtTxt = json['twt_txt'];
    twtRetweetCount = json['twt_retweet_count'];
    favoriteCount = json['favorite_count'];
    twtLang = json['twt_lang'];
    hours = DateTime.now()
        .difference(
            DateTime.fromMillisecondsSinceEpoch(int.parse(twtTime!) * 1000))
        .inHours;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['twt_id'] = this.twtId;
    data['twt_time'] = this.twtTime;
    data['twt_txt'] = this.twtTxt;
    data['twt_retweet_count'] = this.twtRetweetCount;
    data['favorite_count'] = this.favoriteCount;
    data['twt_lang'] = this.twtLang;
    return data;
  }

  @override
  String toString() {
    return 'TwitterModel(id: $id, twtId: $twtId, twtTime: $twtTime, twtTxt: $twtTxt, twtRetweetCount: $twtRetweetCount, favoriteCount: $favoriteCount, twtLang: $twtLang, hours: $hours)';
  }
}
