/// Post model representing blog post data from the API
///
/// This is used for the Cubit example to differentiate from the BLoC User example
class Post {
  final int id;
  final String title;
  final String body;
  final String author;
  final DateTime publishedDate;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.author,
    required this.publishedDate,
  });

  /// Factory constructor to create a Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      author: json['author'] as String,
      publishedDate: DateTime.parse(json['publishedDate'] as String),
    );
  }

  /// Convert Post to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'author': author,
      'publishedDate': publishedDate.toIso8601String(),
    };
  }
}
