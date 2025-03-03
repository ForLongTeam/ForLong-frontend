import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:forlong/models/hospitaldto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/hospital.dart';

class MarkerService {
  static const String baseUrl = "http://3.34.157.88:8080"; // 서버 주소

  /// ✅ 네트워크 이미지를 로컬에 저장
  static Future<String> downloadAndSaveImage(String url, String hospitalName) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        final directory = await getApplicationDocumentsDirectory();
        final filePath = "${directory.path}/${hospitalName}_marker.png";
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        print("✅ 네트워크 이미지 다운로드 완료: $filePath");
        return filePath;
      } else {
        throw Exception("🚨 네트워크 이미지 다운로드 실패 (status: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 이미지 다운로드 오류 발생: $e");
      throw e;
    }
  }

  /// ✅ 마커 이미지 서버에 업로드
  static Future<String?> uploadMarkerImageToServer(String hospitalName, Uint8List imageBytes) async {
    try {
      final request = http.MultipartRequest("POST", Uri.parse("$baseUrl/upload_marker"))
        ..fields['hospital_name'] = hospitalName
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: "${hospitalName}_marker.png",
          contentType: MediaType('image', 'png'),
        ));

      final response = await request.send();
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(await response.stream.bytesToString());
        return jsonResponse['url'];
      }
      print("🚨 마커 이미지 업로드 실패: ${response.statusCode}");
      return null;
    } catch (e) {
      print("🚨 마커 이미지 업로드 중 오류 발생: $e");
      return null;
    }
  }

  /// ✅ 마커 이미지 JSON 서버에 업데이트
  static Future<void> updateMarkerImageJson(String hospitalId, String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/update_marker_json"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "hospital_id": hospitalId,
          "marker_image_url": imageUrl,
        }),
      );

      if (response.statusCode != 200) {
        print("🚨 마커 이미지 JSON 업데이트 실패");
      }
    } catch (e) {
      print("🚨 마커 이미지 JSON 업데이트 중 오류 발생: $e");
    }
  }

  /// ✅ 마커 이미지 생성 및 저장
  static Future<String> getOrCreateCustomMarker(Hospital hospital) async {
    if (hospital.markerImagePath != null && hospital.markerImagePath!.isNotEmpty) {
      print("✅ 기존 마커 이미지 사용: ${hospital.markerImagePath}");
      return hospital.markerImagePath!;
    }

    print("🚀 새로운 마커 이미지 생성 중: ${hospital.name}");

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint()..color = const ui.Color(0xFF1BB881);

    const double scaleFactor = 3.0;
    const double iconSize = 20 * scaleFactor;
    const double paddingLeft = 4 * scaleFactor;
    const double paddingBetween = 6 * scaleFactor;
    const double fontSize = 11 * scaleFactor;
    const double markerHeight = 28 * scaleFactor;
    const double cornerRadius = 14 * scaleFactor;
    const double extraWidth = 5 * scaleFactor;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: hospital.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: ui.FontWeight.bold,
          fontFamily: 'Pretendard',
        ),
      ),
    );

    textPainter.layout();
    final double textWidth = textPainter.width;
    final double markerWidth = textWidth + iconSize + paddingLeft + paddingBetween + extraWidth;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, markerWidth, markerHeight),
      Radius.circular(cornerRadius),
    );
    canvas.drawRRect(rect, paint);

    final circlePaint = Paint()..color = Colors.white;
    final circleCenter = Offset(iconSize / 2 + paddingLeft, markerHeight / 2);
    canvas.drawCircle(circleCenter, iconSize / 2, circlePaint);

    final iconPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: String.fromCharCode(Icons.place.codePoint),
        style: TextStyle(
          fontSize: 12 * scaleFactor,
          fontFamily: Icons.place.fontFamily,
          package: Icons.place.fontPackage,
          color: Color(0xFF1BB881),
        ),
      ),
    );

    iconPainter.layout();
    final double iconOffsetX = paddingLeft + (iconSize - iconPainter.width) / 2;
    final double iconOffsetY = (markerHeight - iconPainter.height) / 2;
    iconPainter.paint(canvas, ui.Offset(iconOffsetX, iconOffsetY));

    final double textOffsetX = iconSize + paddingLeft + paddingBetween - (2 * scaleFactor);
    final double textOffsetY = (markerHeight - textPainter.height) / 2;
    textPainter.paint(canvas, ui.Offset(textOffsetX, textOffsetY));

    final path = ui.Path();
    path.moveTo(markerWidth / 2 - (6 * scaleFactor), markerHeight);
    path.lineTo(markerWidth / 2 + (6 * scaleFactor), markerHeight);
    path.lineTo(markerWidth / 2, markerHeight + (8 * scaleFactor));
    path.close();

    final trianglePaint = Paint()..color = const Color(0xFF1BB881);
    canvas.drawPath(path, trianglePaint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(markerWidth.toInt(), (markerHeight + (8 * scaleFactor)).toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final uint8List = byteData!.buffer.asUint8List();

    // ✅ 로컬에 저장
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/${hospital.name}_marker.png";
    final file = File(filePath);
    await file.writeAsBytes(uint8List);

    print("✅ 로컬 마커 이미지 저장 완료: $filePath");
    hospital.markerImagePath = filePath; // ✅ 마커 경로 업데이트

    return filePath;
  }

  /// ✅ 마커 이미지 생성 및 저장
  static Future<String> getOrCreatedtoCustomMarker(HospitalDto hospital) async {
    if (hospital.markerImagePath != null && hospital.markerImagePath!.isNotEmpty) {
      print("✅ 기존 마커 이미지 사용: ${hospital.markerImagePath}");
      return hospital.markerImagePath!;
    }

    print("🚀 새로운 마커 이미지 생성 중: ${hospital.hospitalName}");

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint()..color = const ui.Color(0xFF1BB881);

    const double scaleFactor = 3.0;
    const double iconSize = 20 * scaleFactor;
    const double paddingLeft = 4 * scaleFactor;
    const double paddingBetween = 6 * scaleFactor;
    const double fontSize = 11 * scaleFactor;
    const double markerHeight = 28 * scaleFactor;
    const double cornerRadius = 14 * scaleFactor;
    const double extraWidth = 5 * scaleFactor;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: hospital.hospitalName,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: ui.FontWeight.bold,
          fontFamily: 'Pretendard',
        ),
      ),
    );

    textPainter.layout();
    final double textWidth = textPainter.width;
    final double markerWidth = textWidth + iconSize + paddingLeft + paddingBetween + extraWidth;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, markerWidth, markerHeight),
      Radius.circular(cornerRadius),
    );
    canvas.drawRRect(rect, paint);

    final circlePaint = Paint()..color = Colors.white;
    final circleCenter = Offset(iconSize / 2 + paddingLeft, markerHeight / 2);
    canvas.drawCircle(circleCenter, iconSize / 2, circlePaint);

    final iconPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: String.fromCharCode(Icons.place.codePoint),
        style: TextStyle(
          fontSize: 12 * scaleFactor,
          fontFamily: Icons.place.fontFamily,
          package: Icons.place.fontPackage,
          color: Color(0xFF1BB881),
        ),
      ),
    );

    iconPainter.layout();
    final double iconOffsetX = paddingLeft + (iconSize - iconPainter.width) / 2;
    final double iconOffsetY = (markerHeight - iconPainter.height) / 2;
    iconPainter.paint(canvas, ui.Offset(iconOffsetX, iconOffsetY));

    final double textOffsetX = iconSize + paddingLeft + paddingBetween - (2 * scaleFactor);
    final double textOffsetY = (markerHeight - textPainter.height) / 2;
    textPainter.paint(canvas, ui.Offset(textOffsetX, textOffsetY));

    final path = ui.Path();
    path.moveTo(markerWidth / 2 - (6 * scaleFactor), markerHeight);
    path.lineTo(markerWidth / 2 + (6 * scaleFactor), markerHeight);
    path.lineTo(markerWidth / 2, markerHeight + (8 * scaleFactor));
    path.close();

    final trianglePaint = Paint()..color = const Color(0xFF1BB881);
    canvas.drawPath(path, trianglePaint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(markerWidth.toInt(), (markerHeight + (8 * scaleFactor)).toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final uint8List = byteData!.buffer.asUint8List();

    // ✅ 로컬에 저장
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/${hospital.hospitalName}_marker.png";
    final file = File(filePath);
    await file.writeAsBytes(uint8List);

    print("✅ 로컬 마커 이미지 저장 완료: $filePath");
    hospital.markerImagePath = filePath; // ✅ 마커 경로 업데이트

    return filePath;
  }
}
