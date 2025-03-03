// ✅ 병원 상태 Enum
enum HospitalStatus {
  open("영업중"),
  lunchBreak("점심시간"),
  closed("영업종료");

  final String value;
  const HospitalStatus(this.value);

  // ✅ JSON -> Enum 변환
  static HospitalStatus fromJson(String json) {
    return HospitalStatus.values.firstWhere(
          (e) => e.value == json,
      orElse: () => HospitalStatus.closed, // 기본값 설정 (영업 종료)
    );
  }

  // ✅ Enum -> JSON 변환
  String toJson() => value;
}

// ✅ 수의사 상태 Enum
enum VetStatus {
  open("영업중"),
  lunchBreak("점심시간"),
  closed("영업종료");

  final String value;
  const VetStatus(this.value);

  // ✅ JSON -> Enum 변환
  static VetStatus fromJson(String json) {
    return VetStatus.values.firstWhere(
          (e) => e.value == json,
      orElse: () => VetStatus.closed, // 기본값 설정 (영업 종료)
    );
  }

  // ✅ Enum -> JSON 변환
  String toJson() => value;
}
