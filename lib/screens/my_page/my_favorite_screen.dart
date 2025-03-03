import 'package:flutter/material.dart';
import '../../favorite_manager.dart';
import '../../widgets/custom_widgets.dart';

class MyFavoriteScreen extends StatefulWidget {
  @override
  _MyFavoriteScreenState createState() => _MyFavoriteScreenState();
}

class _MyFavoriteScreenState extends State<MyFavoriteScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    FavoriteManager.init(onUpdate: _updateFavorites); // ✅ 전역적으로 관리되는 찜 상태 적용
  }

  /// ✅ UI를 즉시 업데이트하는 함수
  void _updateFavorites() {
    setState(() {}); // ✅ FavoriteManager에서 호출됨
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("찜 목록")),
      body: Column(
        children: [
          /// ✅ TabBar 적용
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black, // 선택된 탭 색상
              unselectedLabelColor: Colors.grey, // 비선택 탭 색상
              indicatorColor: Colors.black, // Indicator 색상
              indicatorWeight: 2.5, // Indicator 두께
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: "게시글"),
                Tab(text: "병원"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                /// ✅ 찜한 게시물 리스트
                CustomWidgets.buildPostList(
                  favoritePosts: FavoriteManager.getFavoritePosts(),
                  onToggleFavorite: FavoriteManager.toggleFavoritePost,
                ),
                /// ✅ 찜한 병원 리스트
                CustomWidgets.buildHospitalList(
                  favoriteHospitals: FavoriteManager.getFavoriteHospitals(),
                  onToggleFavorite: FavoriteManager.toggleFavoriteHospital,
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
