import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class ProfileService {
  /// ✅ 프로필 이미지 저장 (로컬)
  static Future<void> saveProfileImage(File imageFile) async {
    final box = await Hive.openBox('userBox');
    final directory = await getApplicationDocumentsDirectory();
    final newPath = "${directory.path}/profile_image.png";
    final newFile = await imageFile.copy(newPath);
    await box.put('profileImagePath', newFile.path);
  }

  /// ✅ 프로필 이미지 경로 불러오기
  static Future<String?> getProfileImagePath() async {
    final box = await Hive.openBox('userBox');
    return box.get('profileImagePath', defaultValue: null);
  }
}
