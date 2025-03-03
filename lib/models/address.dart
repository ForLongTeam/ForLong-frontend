class Address {
  final int id;
  final String zipcode;
  final String fullAddress;
  final String scAddress;
  final String latitude;
  final String longitude;

  Address({
    required this.id,
    required this.zipcode,
    required this.fullAddress,
    required this.scAddress,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      zipcode: json['zipcode'],
      fullAddress: json['fullAddress'],
      scAddress: json['scAddress'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'zipcode': zipcode,
      'fullAddress': fullAddress,
      'scAddress': scAddress,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
