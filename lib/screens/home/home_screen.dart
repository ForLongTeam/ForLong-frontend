import 'package:flutter/material.dart';
import 'package:forlong/screens/my_page/mypage_screen.dart';

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forlong'),
        actions: [
          IconButton(icon: const Icon(Icons.menu), onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MypageScreen(),
                ),
              );
          }),
          IconButton(icon: const Icon(Icons.favorite, color: Color(0xff1bb881)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {})
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Divider(thickness: 0.5, height: 0.5, color: Colors.grey),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildImageMenu('assets/images/icon1.png', '병원찾기'),
                _buildImageMenu('assets/images/icon1.png', '처방전분석'),
                _buildImageMenu('assets/images/icon1.png', '반려수첩'),
                _buildImageMenu('assets/images/icon1.png', '시뮬레이터'),
                _buildImageMenu('assets/images/icon1.png', '급여량계산기'),
                _buildImageMenu('assets/images/icon1.png', '건강수첩'),
                _buildImageMenu('assets/images/icon1.png', '꿀팁사전'),
                _buildImageMenu('assets/images/icon1.png', '질병사전'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildImageMenu(String imagePath, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 25,
          height: 25,
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}