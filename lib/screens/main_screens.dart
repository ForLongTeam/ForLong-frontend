import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:forlong/main.dart';
import 'package:forlong/screens/community/community_screen.dart';
import 'package:forlong/screens/feed/feed_screen.dart';
import 'package:forlong/screens/home/home_screen.dart';
import 'package:forlong/screens/shop/shop_screen.dart';

class MainScreens extends StatefulWidget {
  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(),
          HospitalListScreen(),
          ShopScreen(),
          FeedScreen(),
          CommunityScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            label: '홈', icon: Icon(Icons.home)),
          const BottomNavigationBarItem(
            label: '병원/건강', icon: Icon(Icons.local_hospital)),
          const BottomNavigationBarItem(
            label: '쇼핑', icon: Icon(Icons.shopping_bag)),
          const BottomNavigationBarItem(
            label: '피드', icon: Icon(Icons.search)),
          const BottomNavigationBarItem(
            label: '커뮤니티', icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}