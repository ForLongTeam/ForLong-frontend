import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:forlong/services/social_login_api.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';
import '../../services/local_storage_service.dart';
import '../../models/user_model.dart';

class ProfileEditScreen extends StatefulWidget {
  final UserModel user;

  const ProfileEditScreen({required this.user, Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late UserModel _currentUser;
  late TextEditingController _nicknameController;
  late TextEditingController _addressController;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _nicknameController = TextEditingController(text: _currentUser.nickname);
    _addressController = TextEditingController(text: _currentUser.address ?? "");
    _loadProfileImage();
  }

  /// ✅ **로컬에서 프로필 이미지 경로 불러오기**
  Future<void> _loadProfileImage() async {
    final localImagePath = await LocalStorageService.getProfileImagePath();
    setState(() {
      _profileImagePath = localImagePath ?? _currentUser.profileImage;
    });
  }

  /// ✅ **갤러리에서 이미지 선택 후 저장**
  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final savedPath = await LocalStorageService.saveProfileImage(File(pickedImage.path));

      setState(() {
        _profileImagePath = savedPath;
        _currentUser = _currentUser.copyWith(profileImage: savedPath);
      });

      print("✅ 프로필 이미지 변경됨: $savedPath");
    }
  }

  Future<void> _saveProfile() async {
    final updatedUser = _currentUser.copyWith(
      nickname: _nicknameController.text,
      address: _addressController.text,
      profileImage: _profileImagePath,
    );
    print("🔍 API 요청 전 loginId: ${_currentUser.loginId}");

    // ✅ 서버에 업데이트 요청
    bool success = await ApiService.editUserInfo(
      loginId: updatedUser.loginId, // `user_id` -> `loginId`로 매핑
      nickname: updatedUser.nickname.isNotEmpty ? updatedUser.nickname : "사용자", // 기본값 설정
      email: updatedUser.email?.isNotEmpty == true ? updatedUser.email! : "이메일 없음", // null 방지
      pets: updatedUser.pets != null
          ? updatedUser.pets!.map((pet) => {
        "name": pet.name.isNotEmpty ? pet.name : "반려동물", // 반려동물 이름
        "type": pet.type.isNotEmpty ? pet.type : "알 수 없음", // 반려동물 타입
        "gender": pet.gender.isNotEmpty ? pet.gender : "미상", // 성별
        "age_years": pet.ageYears ?? 0, // 기본값 0
        "age_months": pet.ageMonths ?? 0, // 기본값 0
        "weight": pet.weight ?? 0.0, // 기본값 0.0kg
        "pet_image": pet.petImage?.isNotEmpty == true ? pet.petImage : "", // 기본값 빈 문자열
        "is_representative": pet.isRepresentative ?? false, // 기본값 false
      }).toList()
          : [], // null 방지
    );


    if (success) {
      // ✅ 업데이트 성공 시 로컬 데이터도 갱신
      await LocalStorageService.saveLocalUser(updatedUser);
      print("✅ 유저 정보 서버 업데이트 & 로컬 저장 완료!");
      Navigator.pop(context, updatedUser); // 수정 완료 후 화면 닫기
    } else {
      print("🚨 유저 정보 업데이트 실패");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("유저 정보 업데이트에 실패했습니다.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("프로필 수정")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImagePath != null && File(_profileImagePath!).existsSync()
                    ? FileImage(File(_profileImagePath!))
                    : const AssetImage("assets/images/pet1.png") as ImageProvider,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: "닉네임"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: "주소"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: const Color(0xff1bb881),
              ),
              child: const Text("저장", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
