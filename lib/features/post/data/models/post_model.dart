import '../../domain/entities/post.dart';

/// Post Model - Data Transfer Object
class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.title,
    required super.body,
    required super.author,
    required super.publishedDate,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      author: json['author'] as String,
      publishedDate: DateTime.parse(json['publishedDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'author': author,
      'publishedDate': publishedDate.toIso8601String(),
    };
  }

  Post toEntity() {
    return Post(
      id: id,
      title: title,
      body: body,
      author: author,
      publishedDate: publishedDate,
    );
  }
}
