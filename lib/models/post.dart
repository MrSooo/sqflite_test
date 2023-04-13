class Post {
  final int id;
  final String title;
  final int userId;

  Post({
    required this.id,
    required this.title,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'userId': userId,
    };
  }

  Map toJson() => {
        'id': id,
        'title': title,
        'userId': userId,
      };

  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      title: map['title'],
      userId: map['userId'],
    );
  }
}
