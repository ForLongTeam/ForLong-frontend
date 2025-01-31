import 'package:flutter/material.dart';
import '../../models/hospital.dart';

class HospitalInfoCard extends StatelessWidget {
  final Hospital hospital;

  const HospitalInfoCard({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 병원 썸네일과 정보
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 병원 썸네일
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    hospital.imageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          '   이미지 no.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // 병원 기본 정보 (이름, 위치, 평점 및 거리)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 병원 이름
                      Text(
                        hospital.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // 위치
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Color(0xff1bb881), size: 18),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              hospital.location,
                              style: const TextStyle(color: Color(0xff8EA0AC), fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // 평점 및 거리
                      Row(
                        children: [
                          Text(
                            hospital.region.toString(),
                            style: const TextStyle(fontSize: 14, color: Color(0xff666666)),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.star, color: Colors.orange, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            hospital.rating.toString(),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff666666)),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${hospital.distance} km',
                            style: const TextStyle(fontSize: 14, color: Color(0xff898d99)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 병원 설명
            Text(
              hospital.description,
              style: const TextStyle(color: Colors.black87, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 15),

            // 영업 시간 및 현재 상태
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝 정렬
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.black54, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '영업 시간',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Text(
                  hospital.hours,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝 정렬
              children: [
                Row(
                  children: [
                    const Icon(Icons.business, color: Colors.black54, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '현재 상태',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: hospital.isOpen ? Color(0xff5361f9) : Color(0xff8ea0ac),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    hospital.isOpen ? '진료중' : '진료 종료',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
