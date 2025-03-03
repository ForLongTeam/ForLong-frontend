import 'package:hive/hive.dart';

class Post {
  final String postId;
  final String title;
  final String content;
  final String userId;
  String authorName; // Cached from Hive
  String authorProfileUrl; // Cached from Hive
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;
  final int commentCount;
  final int views; // ✅ Added views field
  final List<String> tags;
  final bool isPinned;

  Post({
    required this.postId,
    required this.title,
    required this.content,
    required this.userId,
    required this.authorName,
    required this.authorProfileUrl,
    this.imageUrl,
    required this.createdAt,
    required this.likes,
    required this.commentCount,
    required this.views, // ✅ Initialize views
    required this.tags,
    this.isPinned = false,
  });

  /// ✅ JSON -> Post object conversion
  factory Post.fromJson(Map<String, dynamic> json) {
    final userBox = Hive.box('userCache'); // Hive caching
    String cachedName = userBox.get('${json['user_id']}_name', defaultValue: json['author_name'] ?? 'Unknown');
    String cachedProfile = userBox.get('${json['user_id']}_profile', defaultValue: json['author_profile_url'] ?? '');

    return Post(
      postId: json['post_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      userId: json['user_id'] ?? '',
      authorName: cachedName,
      authorProfileUrl: cachedProfile,
      imageUrl: json['image_url'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      likes: json['likes'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      views: json['views'] ?? 0, // ✅ Parse views from JSON
      tags: List<String>.from(json['tags'] ?? []),
      isPinned: json['is_pinned'] ?? false,
    );
  }

  /// ✅ Post object -> JSON conversion
  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'title': title,
      'content': content,
      'user_id': userId,
      'author_name': authorName,
      'author_profile_url': authorProfileUrl,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'likes': likes,
      'comment_count': commentCount,
      'views': views, // ✅ Include views in JSON
      'tags': tags,
      'is_pinned': isPinned,
    };
  }

  /// ✅ Update cached user info
  void updateUserCache() {
    final userBox = Hive.box('userCache');
    userBox.put('${userId}_name', authorName);
    userBox.put('${userId}_profile', authorProfileUrl);
  }
}
