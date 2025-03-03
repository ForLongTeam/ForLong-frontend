import 'pet_model.dart';

class UserModel {
  final String loginId;
  final String nickname;
  final String email;
  final String phone;
  final String role;
  final String provider;
  final String providerId;
  final String profileImage;
  final String address;
  final List<Pet> pets;
  final Pet? mainPet; // ✅ 대표 애완동물 필드 추가

  UserModel({
    required this.loginId,
    required this.nickname,
    required this.email,
    required this.phone,
    required this.role,
    required this.provider,
    required this.providerId,
    required this.profileImage,
    required this.address,
    required this.pets,
    this.mainPet, // ✅ 대표 애완동물 필드 추가 (선택적)
  });

  // ✅ JSON -> UserModel 객체 변환
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      loginId: json['loginId'] ?? '',
      nickname: json['nickname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      provider: json['provider'] ?? '',
      providerId: json['provider_id'] ?? '',
      profileImage: json['profile_image'] ?? '',
      address: json['address'] ?? '',
      pets: (json['pets'] as List<dynamic>?)
          ?.map((pet) => Pet.fromJson(pet))
          .toList() ?? [],
      mainPet: json['main_pet'] != null ? Pet.fromJson(json['main_pet']) : null, // ✅ 대표 애완동물 추가
    );
  }

  // ✅ UserModel 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'nickname': nickname,
      'email': email,
      'phone': phone,
      'role': role,
      'provider': provider,
      'provider_id': providerId,
      'profile_image': profileImage,
      'address': address,
      'pets': pets.map((pet) => pet.toJson()).toList(),
      'main_pet': mainPet?.toJson(), // ✅ 대표 애완동물 추가
    };
  }

  // ✅ 특정 필드만 변경할 수 있도록 copyWith 추가
  UserModel copyWith({
    String? nickname,
    String? profileImage,
    String? address,
    List<Pet>? pets, // ✅ pets 추가
    Pet? mainPet, // ✅ 대표 애완동물 추가
  }) {
    return UserModel(
      loginId: this.loginId,
      nickname: nickname ?? this.nickname,
      email: this.email,
      phone: this.phone,
      role: this.role,
      provider: this.provider,
      providerId: this.providerId,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      pets: pets ?? this.pets, // ✅ 기존 리스트 유지 또는 새로운 리스트 적용
      mainPet: mainPet ?? this.mainPet, // ✅ 대표 애완동물 유지 또는 변경 가능
    );
  }
}
