import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:forlong/widgets/profile_header.dart';
import 'package:forlong/widgets/card_list_item.dart';
import 'package:forlong/widgets/pet_info_section.dart';
import 'package:forlong/screens/my_page/profile_edit_screen.dart';

import '../../models/user_model.dart';
import '../../provider/user_provider.dart';

class MypageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('마이페이지'),
        iconTheme: const IconThemeData(color: Color(0xff1bb881)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), color: Colors.black, onPressed: () {}),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user; // ✅ 유저 정보 가져오기
          final pets = user!.pets; // ✅ 반려동물 리스트 가져오기

          return ListView(
            children: [
              /// ✅ **프로필 헤더**
              ProfileHeader(
                user: user,
                onProfileEdit: () async {
                  final updatedUser = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileEditScreen(user: user),
                    ),
                  );

                  if (updatedUser != null && updatedUser is UserModel) {
                    userProvider.updateUser(updatedUser); // ✅ 프로필 수정 반영
                  }
                },
              ),
              const Divider(height: 1, thickness: 0.5),
              const SizedBox(height: 16.0),

              /// ✅ **반려동물 리스트**
              PetInfoSection(
                pets: pets,
                onSetRepresentative: (index) {
                  userProvider.setRepresentativePet(index); // ✅ 대표 반려동물 변경
                },
                onEditPet: (index) {
                  print('${pets[index].name} 정보 수정');
                },
                onAddPet: () {
                  print('새로운 반려동물 추가');
                },
              ),

              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text(
                  '활동',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(height: 8.0),
              CardListItem(title: '내 콘텐츠', onTap: () {}),
              CardListItem(title: '내 가족', onTap: () {}),
              CardListItem(title: '내 찜', onTap: () {}),
            ],
          );
        },
      ),
    );
  }
}
