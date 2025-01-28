import 'package:flutter/material.dart';
import 'package:forlong/widgets/profile_header.dart';
import 'package:forlong/widgets/card_list_item.dart';
import 'package:forlong/widgets/pet_info_section.dart';

class MypageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('마이페이지'),
        iconTheme: IconThemeData(
          color: Color(0xff1bb881),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), color: Colors.black, onPressed: () {}),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Divider(thickness: 0.5, height: 0.5, color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          ProfileHeader(), // 상단 프로필 섹션
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 16.0),
          PetInfoSection(), // 반려동물 정보 섹션
          const SizedBox(height: 24.0),
/*           // 기본 접종 프로그래스바
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xfff7f7f7))
            ),
            child: Center(
              child: Text(
                "기본 접종 프로그래스바",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ), */
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '활동',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          CardListItem(title: '내 콘텐츠', onTap: () {}),
          CardListItem(title: '내 가족', onTap: () {}),
          CardListItem(title: '내 찜', onTap: () {}),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '고객센터',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          CardListItem(title: '1:1 문의', onTap: () {}),
          CardListItem(title: 'FAQ', onTap: () {}),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '설정',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          CardListItem(title: '서비스 정보', onTap: () {}),
          CardListItem(title: '알람(PUSH) 설정', onTap: () {}),
        ],
      ),
    );
  }
}
