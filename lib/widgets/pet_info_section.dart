import 'package:flutter/material.dart';
import '../models/pet_model.dart'; // ✅ Pet 모델 가져오기

class PetInfoSection extends StatelessWidget {
  final List<Pet> pets;
  final Function(int) onSetRepresentative;
  final Function(int) onEditPet;
  final VoidCallback onAddPet;

  const PetInfoSection({
    Key? key,
    required this.pets,
    required this.onSetRepresentative,
    required this.onEditPet,
    required this.onAddPet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// ✅ 가로 스크롤 리스트
        SizedBox(
          height: 180, // 카드 높이 지정
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 가로 스크롤 활성화
            itemCount: pets.length + 1, // ✅ 마지막에 추가 버튼 포함
            itemBuilder: (context, index) {
              /// ✅ 마지막 항목이면 "반려동물 추가" 버튼 표시
              if (index == pets.length) {
                return GestureDetector(
                  onTap: onAddPet,
                  child: Container(
                    width: 280, // ✅ 반려동물 카드와 동일한 너비
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '+ 반려동물 추가',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }

              /// ✅ 반려동물 카드 표시
              final pet = pets[index];

              return Container(
                width: 280, // ✅ 카드 너비 설정
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// ✅ Row로 이미지 + 텍스트 정렬
                    Row(
                      children: [
                        /// ✅ 반려동물 사진
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300, width: 2),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  pet.petImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/images/default_pet.png');
                                  },
                                ),
                              ),
                            ),
                            if (pet.isRepresentative)
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '대표',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(width: 12),

                        /// ✅ 반려동물 정보 텍스트
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              pet.type,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              '${pet.gender} • ${pet.ageYears}년 ${pet.ageMonths}개월 • ${pet.weight}kg',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// ✅ 버튼 정렬 (아래 배치)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!pet.isRepresentative)
                          ElevatedButton(
                            onPressed: () => onSetRepresentative(index),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            child: const Text('대표 설정'),
                          ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => onEditPet(index),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text('정보 수정'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
