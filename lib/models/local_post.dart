import 'package:hive/hive.dart';

part 'local_post.g.dart'; // Hive에서 자동 생성하는 파일

@HiveType(typeId: 1)
class LocalPost extends HiveObject {
  @HiveField(0)
  String postId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  String userId;

  @HiveField(4)
  String authorName;

  @HiveField(5)
  String authorProfileUrl;

  @HiveField(6)
  String? imageUrl;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  int likes;

  @HiveField(9)
  int commentCount;

  @HiveField(10)
  int views;

  @HiveField(11)
  List<String> tags;

  @HiveField(12)
  bool isPinned;

  LocalPost({
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
    required this.views,
    required this.tags,
    this.isPinned = false,
  });

  /// ✅ 로컬 JSON → 객체 변환
  factory LocalPost.fromJson(Map<String, dynamic> json) {
    return LocalPost(
      postId: json['post_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      userId: json['user_id'] ?? '',
      authorName: json['author_name'] ?? 'Unknown',
      authorProfileUrl: json['author_profile_url'] ?? '',
      imageUrl: json['image_url'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      likes: json['likes'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      views: json['views'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      isPinned: json['is_pinned'] ?? false,
    );
  }

  /// ✅ 객체 → 로컬 JSON 변환
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
      'views': views,
      'tags': tags,
      'is_pinned': isPinned,
    };
  }
}
