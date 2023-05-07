class Member {
    String id;
    String jobTitle;

  Member({
    required this.id,
    required this.jobTitle,
  });


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'jobTitle': jobTitle});
  
    return result;
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
    );
  }
}
