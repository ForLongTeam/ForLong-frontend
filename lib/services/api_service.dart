import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/hospital.dart';
import '../models/user_model.dart';
import 'local_storage_service.dart';

class ApiService {
  //static const String baseUrl = "http://172.20.10.6:8080";
  static const String baseUrl = "http://3.34.157.88:8080"; // ✅ 실제 서버 배포된 경우

  /// ✅ **서버에서 유저 데이터 가져오기**
  static Future<UserModel?> fetchUserFromServer(String loginId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/users/$loginId"), // ✅ 올바른 API 경로
        headers: {
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        final user = UserModel.fromJson(userData["data"]); // ✅ 응답 구조에 맞게 수정

        // ✅ 최신 유저 데이터 로컬 저장
        await LocalStorageService.saveLocalUser(user);

        print("✅ 서버에서 최신 유저 데이터 동기화 완료!");
        return user;
      } else {
        print("🚨 서버 요청 실패: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("🚨 서버에서 유저 데이터 불러오기 실패: $e");
    }
    return null;
  }

  /// ✅ **유저 정보 수정 API**
  static Future<bool> editUserInfo({
    required String loginId,
    required String nickname,
    required String email,
    required List<Map<String, dynamic>> pets,
  }) async {
    try {
      final Uri url = Uri.parse("$baseUrl/api/users/$loginId");

      final response = await http.post(
        url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "nickname": nickname,
          "email": email,
          "pets": pets,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ 유저 정보 수정 완료!");
        return true;
      } else {
        print("🚨 유저 정보 수정 실패: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("🚨 서버 요청 오류: $e");
      return false;
    }
  }

  /// ✅ **로컬 JSON에서 유저 데이터 불러오기 (테스트용)**
  static Future<UserModel?> loadUserFromLocalJson() async {
    try {
      final String response = await rootBundle.loadString('assets/user_data.json');
      final Map<String, dynamic> userData = json.decode(response);
      final user = UserModel.fromJson(userData);

      // ✅ 로컬 저장
      await LocalStorageService.saveLocalUser(user);

      print("✅ 로컬 JSON 데이터 불러와 저장 완료!");
      return user;
    } catch (e) {
      print("🚨 로컬 JSON 데이터 불러오기 실패: $e");
      return null;
    }
  }

  /// ✅ **서버에서 병원 데이터 가져오기**
  static Future<List<Hospital>> fetchHospitals() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/hospitals"), // ✅ API 경로 수정
        headers: {
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return (json.decode(response.body)["data"] as List) // ✅ 응답 데이터 구조 확인
            .map((data) => Hospital.fromJson(data))
            .toList();
      }
      throw Exception("🚨 병원 데이터를 불러오는 데 실패했습니다.");
    } catch (e) {
      print("🚨 병원 데이터 요청 실패: $e");
      return [];
    }
  }

  /// ✅ **로컬 JSON에서 병원 데이터 불러오기 (테스트용)**
  static Future<List<Hospital>> fetchHospitalsFromLocal() async {
    try {
      final String response = await rootBundle.loadString('assets/hospitals.json');
      final List<dynamic> data = json.decode(response);
      return data.map((hospitalJson) => Hospital.fromJson(hospitalJson)).toList();
    } catch (e) {
      print("🚨 로컬 병원 데이터 불러오기 실패: $e");
      return [];
    }
  }

  /// ✅ **병원 예약 API**
  static Future<void> bookAppointment({
    required String hospitalId,
    required String date,
    required String time,
    required String pet,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/appointments"), // ✅ API 경로 수정
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode({
          "hospital_id": hospitalId,
          "date": date,
          "time": time,
          "pet": pet,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ 예약 완료!");
      } else {
        throw Exception("🚨 예약 실패: ${response.body}");
      }
    } catch (e) {
      throw Exception("🚨 서버 요청 오류: $e");
    }
  }
}
