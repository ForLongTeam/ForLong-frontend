import 'package:hive_flutter/hive_flutter.dart';
import '../models/post_model.dart';
import '../models/hospital.dart';

class FavoriteService {
  /// ✅ 찜한 게시글 로컬에서 불러오기
  static Future<List<Post>> fetchFavoritePosts() async {
    final box = await Hive.openBox('favorites');
    final List<dynamic> posts = box.get('posts', defaultValue: []);
    return posts.map((e) => Post.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  /// ✅ 찜한 병원 로컬에서 불러오기
  static Future<List<Hospital>> fetchFavoriteHospitals() async {
    final box = await Hive.openBox('favorites');
    final List<dynamic> hospitals = box.get('hospitals', defaultValue: []);
    return hospitals.map((e) => Hospital.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  /// ✅ 찜한 게시글 저장
  static Future<void> updateFavoritePosts(List<Post> posts) async {
    final box = await Hive.openBox('favorites');
    box.put('posts', posts.map((e) => e.toJson()).toList());
  }

  /// ✅ 찜한 병원 저장
  static Future<void> updateFavoriteHospitals(List<Hospital> hospitals) async {
    final box = await Hive.openBox('favorites');
    box.put('hospitals', hospitals.map((e) => e.toJson()).toList());
  }
}
