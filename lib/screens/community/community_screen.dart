import 'package:flutter/material.dart';
import '../../services/post_api_service.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final PostApiService apiService = PostApiService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  void _submitPost() async {
    String loginId = "kakao_test@naver.com"; // 로그인된 사용자 정보 (테스트 데이터)
    String title = titleController.text;
    String content = contentController.text;

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("제목과 내용을 입력해주세요.")),
      );
      return;
    }

    final response = await apiService.createPost(
      loginId: loginId,
      title: title,
      content: content,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response["message"])),
    );

    if (response["status"] == "success") {
      titleController.clear();
      contentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("커뮤니티")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "제목"),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: "내용"),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text("게시글 등록"),
            ),
          ],
        ),
      ),
    );
  }
}
