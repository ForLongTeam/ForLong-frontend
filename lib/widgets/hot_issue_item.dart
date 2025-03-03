import 'package:flutter/material.dart';
import 'package:forlong/models/server_post.dart';

class HotIssueItem extends StatelessWidget {
  final ServerPost post;

  const HotIssueItem({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        post.title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${post.views} views'),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        print('✅ ${post.title} 클릭됨');
      },
    );
  }
}
