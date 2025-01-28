import 'package:flutter/material.dart';
import 'package:forlong/screens/hospital/reservation_screen.dart';
import '../../models/hospital.dart';
import '../../widgets/custom_widgets.dart';

class HospitalDetailScreen extends StatefulWidget {
  final Hospital hospital; // 병원 정보 모델

  const HospitalDetailScreen({super.key, required this.hospital});

  @override
  _HospitalDetailScreenState createState() => _HospitalDetailScreenState();
}

class _HospitalDetailScreenState extends State<HospitalDetailScreen> {
  bool isBookmarked = false; // 찜 여부 상태 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              widget.hospital.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    '이미지를 불러올 수 없습니다.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            CustomWidgets.buildTag(widget.hospital.status, const Color(0xdd5361f9)),
                            const SizedBox(width: 8),
                            CustomWidgets.buildTag(widget.hospital.region, Colors.grey[300]!),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.hospital.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        CustomWidgets.buildInfoRow('위치', widget.hospital.location),
                        CustomWidgets.buildInfoRow('연락처', widget.hospital.phone),
                        CustomWidgets.buildInfoRow('홈페이지', widget.hospital.website, isLink: true),
                        const SizedBox(height: 20),
                        const Text(
                          '병원 정보',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.hospital.description,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                },
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: 30,
                  color: isBookmarked ? const Color(0xff4DAEEB) : Colors.grey,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationScreen(hospital: widget.hospital),
                    ),
                  ); // 예약 기능 추가
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1BB881),
                  minimumSize: const Size(290, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                label: const Text(
                  '예약하기',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
