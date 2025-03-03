import 'package:flutter/material.dart';
import '../models/pet_model.dart';

class UserPetProfile extends StatefulWidget {
  final Pet? mainPet;

  const UserPetProfile({Key? key, required this.mainPet}) : super(key: key);

  @override
  _UserPetProfileState createState() => _UserPetProfileState();
}

class _UserPetProfileState extends State<UserPetProfile> {
  @override
  Widget build(BuildContext context) {
    if (widget.mainPet == null) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("대표 반려동물이 등록되지 않았습니다."),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0, top: 10.0),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 3),
              ),
              child: ClipOval(
                child: Image.network(
                  widget.mainPet!.petImage,
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.mainPet!.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${widget.mainPet!.type} • ${widget.mainPet!.ageYears}년 ${widget.mainPet!.ageMonths}개월',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
