import 'package:flutter/material.dart';

class PetInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset('assets/images/pet1.png', fit: BoxFit.cover,),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            '루리',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8.0),
          // 반려동물 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '골든햄스터',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                child: Text(
                  '2살',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                '암컷',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
