import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/hospital.dart';
import '../models/hospitaldto.dart';

class HospitalService {
  /// ✅ 로컬 JSON에서 병원 데이터 가져오기 (테스트용)
  static Future<List<Hospital>> fetchHospitalsFromLocal() async {
    final String response = await rootBundle.loadString('assets/hospitals.json');
    final List<dynamic> data = json.decode(response);
    return data.map((hospitalJson) => Hospital.fromJson(hospitalJson)).toList();
  }

  /// ✅ 병원 검색 API 호출
  static Future<List<HospitalDto>> fetchHospitalsFromApi(String query) async {
    const String apiUrl = "http://192.168.35.83:8080/api/hospitals/search"; // 실제 서버 주소로 변경
    //const String apiUrl = "http://localhost:8080/api/hospitals/search"; // 실제 서버 주소로 변경

    final response = await http.get(
      Uri.parse("$apiUrl?query=$query"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      // ✅ UTF-8로 디코딩하여 한글 깨짐 방지
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((hospitalJson) => HospitalDto.fromJson(hospitalJson)).toList();
    } else {
      throw Exception("🚨 병원 검색 실패: ${response.statusCode}");
    }
  }
}
