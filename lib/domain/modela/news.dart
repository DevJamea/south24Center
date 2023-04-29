class News {
  String title;
  String description;
  String enclosure;
  String link;
  String pubDate;
  News({
    required this.title,
    required this.description,
    required this.enclosure,
    required this.link,
    required this.pubDate,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'enclosure': enclosure});
    result.addAll({'link': link});
    result.addAll({'pubDate': pubDate});

    return result;
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      enclosure: map['enclosure'] ?? '',
      link: map['link'] ?? '',
      pubDate: map['pubDate'] ?? '',
    );
  }
}

