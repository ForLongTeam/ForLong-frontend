import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:forlong/models/server_post.dart';
import 'package:forlong/screens/community/community_screen.dart';
import 'package:forlong/screens/home/home_screen.dart';
import 'package:forlong/screens/hospital/hospital_search_screen.dart';
import 'package:forlong/screens/my_page/my_favorite_screen.dart';
import 'package:forlong/screens/my_page/mypage_screen.dart';
import 'package:forlong/services/content_service.dart';

import '../provider/user_provider.dart'; // ✅ 서비스 불러오기

class MainScreens extends StatefulWidget {
  const MainScreens({Key? key}) : super(key: key);

  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  int _selectedIndex = 2;
  List<ServerPost> _recentVetReplies = [];
  List<ServerPost> _hotIssues = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  void _loadContent() async {
    var contentData = await ContentService.loadHomeContent();

    print("🔹 최근 수의사 문의글: ${contentData['recentVetReplies']}");
    print("🔥 핫이슈: ${contentData['hotIssues']}");

    setState(() {
      _recentVetReplies = contentData['recentVetReplies'] ?? [];
      _hotIssues = contentData['hotIssues'] ?? [];
      _isLoading = false; // ✅ 로딩 상태 해제
    });
  }

  @override
  Widget build(BuildContext context) {
    /// ✅ `UserProvider`를 통해 유저 정보 가져오기 (자동 업데이트 가능)
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user; // ✅ 현재 유저 정보

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // ✅ 로딩 표시
          : IndexedStack(
        index: _selectedIndex,
        children: [
          CommunityScreen(),
          HospitalSearchScreen(),
          HomeScreen(
            recentVetReplies: _recentVetReplies,
            hotIssues: _hotIssues,
          ),
          MyFavoriteScreen(),
          MypageScreen(), // ✅ 마이페이지에서도 `UserProvider` 사용
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xff1bb881),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(label: '커뮤니티', icon: Icon(Icons.chat)),
          BottomNavigationBarItem(label: '병원', icon: Icon(Icons.local_hospital_outlined)),
          BottomNavigationBarItem(label: '홈', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: '찜목록', icon: Icon(Icons.bookmark)),
          BottomNavigationBarItem(label: '프로필', icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
