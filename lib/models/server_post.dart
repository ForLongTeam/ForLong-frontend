class ServerPost {
  final String postId;
  final String title;
  final String content;
  final String userId;
  final String authorName;
  final String authorProfileUrl;
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;
  final int commentCount;
  final int views;
  final List<String> tags;
  final bool isPinned;

  ServerPost({
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

  /// ✅ 서버 JSON → 객체 변환 (Hive 사용 X)
  factory ServerPost.fromJson(Map<String, dynamic> json) {
    return ServerPost(
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

  /// ✅ 객체 → 서버 JSON 변환
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
