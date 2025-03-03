import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:forlong/models/server_post.dart';
import 'package:forlong/widgets/user_pet_profile.dart';
import 'package:forlong/widgets/vet_post_card.dart';
import 'package:forlong/widgets/hot_issue_item.dart';
import 'package:forlong/widgets/section_title.dart';

import '../../provider/user_provider.dart';

class HomeScreen extends StatelessWidget {
  final List<ServerPost> recentVetReplies;
  final List<ServerPost> hotIssues;

  const HomeScreen({
    Key? key,
    required this.recentVetReplies,
    required this.hotIssues,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경을 흰색으로 설정
      appBar: AppBar(
        backgroundColor: Colors.white, // 배경을 흰색으로 설정
        surfaceTintColor: Colors.transparent, // 배경 색 변화를 방지
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Forlong',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Divider(thickness: 0.5, height: 0.5, color: Colors.grey),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                /// ✅ **대표 반려동물 프로필 (자동 갱신)**
                UserPetProfile(mainPet: userProvider.user!.mainPet),

                const SizedBox(height: 20),

                /// ✅ **그리드 메뉴**
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildIconMenu(Icons.shopping_cart, '마켓', Colors.black, () {}),
                      _buildIconMenu(Icons.pets, '입양', const Color(0xdd5361f9), () {}),
                      _buildIconMenu(Icons.description, '처방전 분석', const Color(0xff1BB881), () {}),
                      _buildIconMenu(Icons.healing, '질병 사전', Colors.orange, () {}),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// ✅ **의사선생님께 여쭤보기 (가로 스크롤)**
                const SectionTitle(title: '👨‍⚕️ 의사선생님께 여쭤보기'),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentVetReplies.length,
                    itemBuilder: (context, index) {
                      return VetPostCard(post: recentVetReplies[index]);
                    },
                  ),
                ),

                const SizedBox(height: 30),

                /// ✅ **Hot Issue (조회수 높은 게시글)**
                const SectionTitle(title: '🔥 Hot Issue'),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hotIssues.length > 5 ? 5 : hotIssues.length,
                  itemBuilder: (context, index) {
                    return HotIssueItem(post: hotIssues[index]);
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ✅ **그리드 메뉴 아이콘**
  Widget _buildIconMenu(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
