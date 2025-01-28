import 'package:flutter/material.dart';

class CardListItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CardListItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontSize: 13)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xff1bb881)),
          onTap: onTap,
        ),
        const Divider(height: 1, thickness: 0.5),
      ],
    );
  }
}
