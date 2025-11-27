/// Post entity - Pure business object
///
/// DOMAIN ENTITY:
/// - Represents a blog post in business terms
/// - Contains only business-relevant fields
/// - No JSON serialization logic (that's in PostModel)
/// - No external dependencies
///
/// IMMUTABILITY:
/// - All fields are final
/// - Use const constructor when possible
/// - To "update" a post, create a new instance
///
/// BUSINESS LOGIC EXAMPLES:
/// - Validation: isValidPost(), hasContent()
/// - Computations: readingTime(), wordCount()
/// - Comparisons: isNewerThan(other), isSameAuthor(other)
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

  // Optional business logic methods:
  // int get wordCount => body.split(' ').length;
  // int get readingTimeMinutes => (wordCount / 200).ceil();
  // bool get isRecent => DateTime.now().difference(publishedDate).inDays < 7;
}
