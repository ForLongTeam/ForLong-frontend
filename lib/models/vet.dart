import 'unavailabledate.dart';

class Vet {
  final int id;
  final String vetName;
  final String status;
  final DateTime time;
  final List<UnavailableDate> unavailableDates;

  Vet({
    required this.id,
    required this.vetName,
    required this.status,
    required this.time,
    required this.unavailableDates,
  });

  factory Vet.fromJson(Map<String, dynamic> json) {
    return Vet(
      id: json['id'],
      vetName: json['vet_name'],
      status: json['status'],
      time: DateTime.parse(json['time']),
      unavailableDates: (json['unavailableDates'] as List<dynamic>?)
          ?.map((date) => UnavailableDate.fromJson(date))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vet_name': vetName,
      'status': status,
      'time': time.toIso8601String(),
      'unavailableDates':
      unavailableDates.map((date) => date.toJson()).toList(),
    };
  }
}
