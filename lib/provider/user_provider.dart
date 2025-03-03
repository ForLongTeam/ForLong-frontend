import 'package:flutter/material.dart';
import 'package:forlong/models/pet_model.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserProvider([this._user]);

  UserModel? get user => _user;

  /// ✅ 대표 반려동물 변경
  void setRepresentativePet(int index) {
    if (index < 0 || index >= _user!.pets.length) return;

    // ✅ 모든 반려동물의 대표 상태 해제
    List<Pet> updatedPets = _user!.pets.map((pet) {
      return pet.copyWith(isRepresentative: false);
    }).toList();

    // ✅ 선택된 반려동물을 대표로 설정
    updatedPets[index] = updatedPets[index].copyWith(isRepresentative: true);

    // ✅ 변경된 반려동물 리스트와 대표 반려동물 적용
    _user = _user!.copyWith(pets: updatedPets, mainPet: updatedPets[index]);

    notifyListeners(); // ✅ UI 자동 갱신
  }

  /// ✅ 반려동물 추가
  void addPet(Pet pet) {
    List<Pet> updatedPets = List.from(_user!.pets)..add(pet);
    _user = _user!.copyWith(pets: updatedPets);

    notifyListeners(); // ✅ UI 자동 갱신
  }

  /// ✅ 반려동물 삭제
  void removePet(int index) {
    if (index < 0 || index >= _user!.pets.length) return;

    List<Pet> updatedPets = List.from(_user!.pets)..removeAt(index);

    // ✅ 삭제 후 대표 반려동물이 없으면 첫 번째 동물을 대표로 설정
    Pet? newMainPet;
    if (updatedPets.isNotEmpty) {
      updatedPets[0] = updatedPets[0].copyWith(isRepresentative: true);
      newMainPet = updatedPets[0];
    }

    _user = _user!.copyWith(pets: updatedPets, mainPet: newMainPet);

    notifyListeners(); // ✅ UI 자동 갱신
  }

  /// ✅ 유저 정보 업데이트 (프로필 수정 시)
  void updateUser(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners(); // ✅ UI 자동 갱신
  }

  /// ✅ 유저 정보 업데이트 (자동 로그인 시 필요)
  void setUser(UserModel user) {
    _user = user;
    notifyListeners(); // ✅ UI 자동 업데이트
  }
}
