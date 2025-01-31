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

  Hospital({
    required this.name,
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
    required this.region,
    required this.status,
    required this.openingHours,
    this.markerImagePath,
  });
}
