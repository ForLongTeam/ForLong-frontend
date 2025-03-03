class Pet {
  final String name;
  final String type; // 예: 강아지, 고양이, 햄스터 등
  final String gender; // 예: 수컷, 암컷
  final int ageYears; // 나이 (년)
  final int ageMonths; // 나이 (개월)
  final double weight; // 무게 (kg)
  final String petImage; // 반려동물 사진 경로
  final bool isRepresentative; // 대표 동물 여부 (true: 대표, false: 일반)

  const Pet({
    required this.name,
    required this.type,
    required this.gender,
    required this.ageYears,
    required this.ageMonths,
    required this.weight,
    required this.petImage,
    this.isRepresentative = false, // 기본값: 대표 동물이 아님
  });

  /// ✅ JSON -> Pet 객체 변환
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      gender: json['gender'] ?? '',
      ageYears: json['age_years'] ?? 0,
      ageMonths: json['age_months'] ?? 0,
      weight: (json['weight'] ?? 0).toDouble(),
      petImage: json['pet_image'] ?? '',
      isRepresentative: json['is_representative'] ?? false,
    );
  }

  /// ✅ Pet 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'gender': gender,
      'age_years': ageYears,
      'age_months': ageMonths,
      'weight': weight,
      'pet_image': petImage,
      'is_representative': isRepresentative,
    };
  }

  /// ✅ `copyWith()` 추가: 기존 객체를 기반으로 새로운 `Pet` 객체 생성
  Pet copyWith({
    String? name,
    String? type,
    String? gender,
    int? ageYears,
    int? ageMonths,
    double? weight,
    String? petImage,
    bool? isRepresentative,
  }) {
    return Pet(
      name: name ?? this.name,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      ageYears: ageYears ?? this.ageYears,
      ageMonths: ageMonths ?? this.ageMonths,
      weight: weight ?? this.weight,
      petImage: petImage ?? this.petImage,
      isRepresentative: isRepresentative ?? this.isRepresentative,
    );
  }
}
