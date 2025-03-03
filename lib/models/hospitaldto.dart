import 'enums.dart';
import 'vet.dart';
import 'address.dart';

class HospitalDto {
  final int id;
  final String hospitalName;
  final String hospitalPhone;
  final HospitalStatus hospitalStatus; // ✅ Enum 적용
  final DateTime time;
  final String explainHospital;
  final DateTime breaktime;
  final Address address;
  final List<Vet> vets;
  final String formattedTime;
  final String formattedBreaktime;
  final bool currentlyOpen;
  final int vetCount;
  String? markerImagePath;

  HospitalDto({
    required this.id,
    required this.hospitalName,
    required this.hospitalPhone,
    required this.hospitalStatus, // ✅ Enum 적용
    required this.time,
    required this.explainHospital,
    required this.breaktime,
    required this.address,
    required this.vets,
    required this.formattedTime,
    required this.formattedBreaktime,
    required this.currentlyOpen,
    required this.vetCount,
    this.markerImagePath,
  });

  // ✅ JSON -> HospitalDto 변환 (fromJson)
  factory HospitalDto.fromJson(Map<String, dynamic> json) {
    return HospitalDto(
      id: json['id'],
      hospitalName: json['hospitalName'],
      hospitalPhone: json['hospitalPhone'],
      hospitalStatus: HospitalStatus.fromJson(json['hospitalStatus']), // ✅ Enum 변환
      time: DateTime.parse(json['time']),
      explainHospital: json['explainHospital'],
      breaktime: DateTime.parse(json['breaktime']),
      address: Address.fromJson(json['address']),
      vets: (json['vets'] as List<dynamic>?)
          ?.map((vet) => Vet.fromJson(vet))
          .toList() ??
          [],
      formattedTime: json['formattedTime'],
      formattedBreaktime: json['formattedBreaktime'],
      currentlyOpen: json['currentlyOpen'],
      vetCount: json['vetCount'],
    );
  }

  // ✅ HospitalDto -> JSON 변환 (toJson)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hospitalName': hospitalName,
      'hospitalPhone': hospitalPhone,
      'hospitalStatus': hospitalStatus.toJson(), // ✅ Enum 변환
      'time': time.toIso8601String(),
      'explainHospital': explainHospital,
      'breaktime': breaktime.toIso8601String(),
      'address': address.toJson(),
      'vets': vets.map((vet) => vet.toJson()).toList(),
      'formattedTime': formattedTime,
      'formattedBreaktime': formattedBreaktime,
      'currentlyOpen': currentlyOpen,
      'vetCount': vetCount,
    };
  }
}

