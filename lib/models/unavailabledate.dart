class UnavailableDate {
  final int id;
  final DateTime notDate;
  final String vet;

  UnavailableDate({
    required this.id,
    required this.notDate,
    required this.vet,
  });

  factory UnavailableDate.fromJson(Map<String, dynamic> json) {
    return UnavailableDate(
      id: json['id'],
      notDate: DateTime.parse(json['not_date']),
      vet: json['vet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'not_date': notDate.toIso8601String(),
      'vet': vet,
    };
  }
}
