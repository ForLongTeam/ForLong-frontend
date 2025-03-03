import 'package:flutter/material.dart';
import 'package:forlong/models/server_post.dart'; // ✅ ServerPost 사용

class VetPostCard extends StatelessWidget {
  final ServerPost post; // ✅ Post → ServerPost로 변경

  const VetPostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: GestureDetector(
        onTap: () {
          print('✅ ${post.title} 클릭됨');
        },
        child: Container(
          width: 360, // ✅ 카드 가로 크기
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title, // ✅ ServerPost의 title
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  '🩺 ${post.authorName}', // ✅ 서버 데이터에서는 userId 대신 authorName 사용
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
