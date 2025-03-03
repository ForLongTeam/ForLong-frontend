class Hospital {
  final String name;
  final String status;
  final String region;
  final String location;
  final double latitude;
  final double longitude;
  final String phone;
  final String website;
  final String imageUrl;
  final String description;
  final double rating;
  final double distance;
  final String hours;
  final bool isOpen;
  final String openingHours;
  String? markerImagePath; // 마커 이미지 경로 (nullable)
  final List<Map<String, dynamic>> availableTimes; // ✅ 예약 가능 시간 추가

  Hospital({
    required this.name,
    required this.status,
    required this.region,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.website,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.distance,
    required this.hours,
    required this.isOpen,
    required this.openingHours,
    this.markerImagePath,
    required this.availableTimes, // ✅ 추가
  });

  // ✅ JSON -> Hospital 객체 변환 (안전한 변환 처리)
  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      region: json['region'] ?? '',
      location: json['location'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      distance: (json['distance'] ?? 0.0).toDouble(),
      hours: json['hours'] ?? '',
      isOpen: json['isOpen'] ?? false,
      openingHours: json['openingHours'] ?? '',
      markerImagePath: json['markerImagePath'], // nullable 처리
      availableTimes: (json['availableTimes'] as List<dynamic>?)?.map((e) {
        return Map<String, dynamic>.from(e as Map);
      }).toList() ?? [], // ✅ 안전한 변환 추가
    );
  }

  // ✅ Hospital 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'region': region,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'website': website,
      'imageUrl': imageUrl,
      'description': description,
      'rating': rating,
      'distance': distance,
      'hours': hours,
      'isOpen': isOpen,
      'openingHours': openingHours,
      'markerImagePath': markerImagePath, // nullable 처리
      'availableTimes': availableTimes, // ✅ 추가
    };
  }
}
