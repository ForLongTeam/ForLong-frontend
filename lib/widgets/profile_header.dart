import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  final VoidCallback onProfileEdit; // ✅ 콜백 추가

  const ProfileHeader({required this.user, required this.onProfileEdit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: user.profileImage.isNotEmpty && File(user.profileImage).existsSync()
                ? FileImage(File(user.profileImage))
                : const AssetImage("assets/images/pet1.png") as ImageProvider,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nickname,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.address,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onProfileEdit,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xffF7F7F7)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: const Color(0xffF7F7F7),
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              '프로필 수정',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xff898D99),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
