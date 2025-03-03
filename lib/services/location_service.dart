import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static const String clientId = "29brsoczm8"; // 네이버 API Client ID
  static const String clientSecret = "ObXGmWzvRdfqlGP3LULXuX41Kt5y0fbQc6LWzuxb"; // 네이버 API Client Secret
  static const String reverseGeocodeUrl = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc";

  final Dio dio = Dio();

  /// ✅ 현재 위치의 위도/경도를 가져오는 함수
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("위치 서비스가 비활성화되었습니다.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("위치 권한이 거부되었습니다.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("위치 권한이 영구적으로 거부되었습니다. 설정에서 변경해주세요.");
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  /// ✅ 위도, 경도로 네이버 API를 통해 주소 변환
  Future<String?> _getAddressFromCoords(double latitude, double longitude) async {
    final Uri url = Uri.parse(
        "$reverseGeocodeUrl?coords=$longitude,$latitude&sourcecrs=epsg:4326&output=json&orders=addr,roadaddr"
    );
    try {
      final response = await dio.get(
        url.toString(),
        options: Options(
          headers: {
            "X-NCP-APIGW-API-KEY-ID": clientId,
            "X-NCP-APIGW-API-KEY": clientSecret,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final results = data["results"] as List<dynamic>;

        if (results.isNotEmpty) {
          final region = results[0]["region"];
          final land = results[0]["land"];

          String area1 = region["area1"]["name"] ?? ""; // 도/광역시
          String area2 = region["area2"]["name"] ?? ""; // 시/구
          String area3 = region["area3"]["name"] ?? ""; // 동
          String landNumber = land?["number1"] ?? ""; // 번지 (없을 수도 있음)

          String fullAddress = "$area1 $area2 $area3 $landNumber".trim();

          print("📍 변환된 주소: $fullAddress");
          return fullAddress.isNotEmpty ? fullAddress : "주소 정보 없음";
        } else {
          print("🚨 주소 데이터 없음.");
          return "주소 데이터 없음";
        }
      } else {
        print("🚨 네이버 역지오코딩 실패: ${response.statusCode} - ${response.data}");
      }
    } catch (e) {
      print("❌ 네이버 Reverse Geocoding 요청 중 오류 발생: $e");
    }
    return null;
  }

  /// ✅ 현재 위치를 가져와 주소로 변환
  Future<String> getCurrentAddress() async {
    try {
      Position position = await _getCurrentPosition();
      print("📍 현재 위치: ${position.latitude}, ${position.longitude}");

      String? address = await _getAddressFromCoords(position.latitude, position.longitude);
      if (address == null) {
        print("🚨 네이버 API로 주소 변환 실패");
      }
      return address ?? "주소를 가져올 수 없습니다.";
    } catch (e) {
      print("🚨 위치 정보 가져오기 실패: $e");
      return "주소 변환 중 오류 발생: $e";
    }
  }
}
