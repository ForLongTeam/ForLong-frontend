import 'package:forlong/models/hospitaldto.dart';
import 'package:hive/hive.dart';
import '../models/hospital.dart';
import '../models/post_model.dart';

class DtoFavoriteManager{
  static late Box _favoriteBox;
  static List<HospitalDto> favoriteHospitals = [];
  static List<Post> favoritePosts = [];
  static Function()? _updateUI;

  /// ✅ 초기화 (앱 실행 시 한 번만 호출)
  static Future<void> init({Function()? onUpdate}) async {
    _favoriteBox = await Hive.openBox('dto_favorites');

    // ✅ Hive에서 병원 데이터 불러오기 (JSON 변환 X)
    var storedHospitals = _favoriteBox.get('hospitaldtos', defaultValue: []);
    if (storedHospitals is List) {
      favoriteHospitals = storedHospitals.whereType<HospitalDto>().toList(); // ✅ Hospital 리스트로 변환
    } else {
      favoriteHospitals = [];
    }

    // ✅ Hive에서 게시글 데이터 불러오기 (JSON 변환 X)
    var storedPosts = _favoriteBox.get('posts', defaultValue: []);
    if (storedPosts is List) {
      favoritePosts = storedPosts.whereType<Post>().toList(); // ✅ Post 리스트로 변환
    } else {
      favoritePosts = [];
    }

    _updateUI = onUpdate;
  }

  /// ✅ 병원이 찜 상태인지 확인
  static bool isFavoriteHospital(HospitalDto hospital) {
    return favoriteHospitals.contains(hospital);
  }

  /// ✅ 게시글이 찜 상태인지 확인
  static bool isFavoritePost(Post post) {
    return favoritePosts.contains(post);
  }

  /// ✅ 병원 찜 토글
  static void toggleFavoriteHospital(HospitalDto hospital) {
    if (isFavoriteHospital(hospital)) {
      favoriteHospitals.remove(hospital);
    } else {
      favoriteHospitals.add(hospital);
    }

    // ✅ Hive에 리스트 그대로 저장 (JSON 변환 X)
    _favoriteBox.put('hospitaldtos', favoriteHospitals);

    _updateUI?.call();
  }

  /// ✅ 게시글 찜 토글
  static void toggleFavoritePost(Post post) {
    if (isFavoritePost(post)) {
      favoritePosts.remove(post);
    } else {
      favoritePosts.add(post);
    }

    // ✅ Hive에 리스트 그대로 저장 (JSON 변환 X)
    _favoriteBox.put('posts', favoritePosts);

    _updateUI?.call();
  }

  /// ✅ 찜한 병원 리스트 반환
  static List<HospitalDto> getFavoriteHospitals() {
    return favoriteHospitals;
  }

  /// ✅ 찜한 게시글 리스트 반환
  static List<Post> getFavoritePosts() {
    return favoritePosts;
  }
}
