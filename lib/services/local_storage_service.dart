import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_model.dart';

class LocalStorageService {
  static const String _userBoxName = 'userBox';
  static late Box _userBox; // 🔥 전역 변수로 Box 관리

  /// ✅ **초기화: 앱 실행 시 한 번만 호출**
  static Future<void> init() async {
    await Hive.initFlutter();
    _userBox = await Hive.openBox(_userBoxName);
  }

  /// ✅ **userBox에 저장된 모든 데이터 확인**
  static Future<void> printUserBoxContents() async {
    await init(); // ✅ 박스가 열려 있지 않다면 초기화

    if (_userBox == null) {
      print("🚨 userBox가 초기화되지 않았습니다.");
      return;
    }

    print("📦 userBox에 저장된 데이터:");
    for (var key in _userBox!.keys) {
      print("🔑 Key: $key, 📄 Value: ${_userBox!.get(key)}");
    }
  }

  /// ✅ **Hive에서 유저 데이터 가져오기**
  static Future<UserModel?> fetchLocalUser() async {
    final dynamic data = _userBox.get('userData');

    if (data == null || data is! Map<String, dynamic>) {
      return null;
    }
    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }

  /// ✅ **Hive에 유저 데이터 저장**
  static Future<void> saveLocalUser(UserModel user) async {
    await _userBox.put('userData', user.toJson());
  }

  /// ✅ **Hive에 저장된 유저 데이터 삭제 (테스트용)**
  static Future<void> clearLocalUser() async {
    await _userBox.clear();
  }

  /// ✅ **로컬 JSON 파일에서 유저 데이터 불러오기 (테스트용)**
  static Future<UserModel?> loadUserFromLocalJson() async {
    try {
      final String response = await rootBundle.loadString('assets/user_data.json');
      final Map<String, dynamic> userData = json.decode(response);
      final user = UserModel.fromJson(userData);

      // ✅ 로컬(Hive)에 저장
      await saveLocalUser(user);

      print("✅ 로컬 JSON 데이터 불러와 저장 완료!");
      return user;
    } catch (e) {
      print("🚨 로컬 JSON 데이터 불러오기 실패: $e");
      return null;
    }
  }

  /// ✅ **프로필 이미지 저장 (파일 삭제 후 저장)**
  static Future<String> saveProfileImage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final String newPath = "${directory.path}/profile_image_${DateTime.now().millisecondsSinceEpoch}.png";

    // ✅ 기존 파일 삭제 (기존 이미지가 있다면 삭제)
    final String? oldPath = _userBox.get('profileImagePath');
    if (oldPath != null && File(oldPath).existsSync()) {
      File(oldPath).deleteSync();
    }

    // ✅ 새 이미지 저장
    final newFile = await imageFile.copy(newPath);
    await _userBox.put('profileImagePath', newFile.path);

    return newFile.path;
  }

  /// ✅ **저장된 프로필 이미지 경로 가져오기**
  static Future<String?> getProfileImagePath() async {
    return _userBox.get('profileImagePath', defaultValue: null);
  }
}
