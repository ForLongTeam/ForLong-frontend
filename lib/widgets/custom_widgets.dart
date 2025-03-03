import 'package:flutter/material.dart';
import 'package:forlong/models/hospitaldto.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/hospital.dart';
import '../models/post_model.dart';
import '../screens/hospital/hospital_detail_screen.dart';
import '../screens/hospital/hospitaldto_detail_screen.dart';
import '../screens/hospital/hospitaldto_reservation_screen.dart';
import '../screens/hospital/reservation_screen.dart';

class CustomWidgets {
  static Widget buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color == const Color(0xdd5361f9) ? Colors.white : const Color(0xff8ea0ac),
        ),
      ),
    );
  }

  static Widget buildInfoRow(String title, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          isLink
              ? Text(
            value,
            style: const TextStyle(color: Colors.blue),
          )
              : Text(value),
        ],
      ),
    );
  }

  static Widget buildReservationSection({
    required BuildContext context,
    required String selectedPet,
    required String selectedDate,
    required String selectedTime,
    required Function(String) onPetSelect,
    required Function(String) onDateSelect,
    required Function(String) onTimeSelect,
    required Function(String, Function(String)) selectOption, // ✅ 추가된 매개변수

  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildSelectionRow(
            context: context,
            title: '반려동물',
            value: selectedPet,
            onSelect: onPetSelect,
            selectOption: selectOption, // ✅ 전달
          ),
          buildSelectionRow(
            context: context,
            title: '예약일',
            value: selectedDate,
            onSelect: onDateSelect,
            selectOption: selectOption, // ✅ 전달
          ),
          buildSelectionRow(
            context: context,
            title: '예약시간',
            value: selectedTime,
            onSelect: onTimeSelect,
            selectOption: selectOption, // ✅ 전달
          ),
        ],
      ),
    );
  }

  /// ✅ 예약 버튼 UI
  static Widget buildBottomButton({
    required bool isAgreed,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: isAgreed ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isAgreed ? const Color(0xff1bb881) : Colors.grey,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text('예약하기', style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  /// ✅ 선택 항목 UI (예약 정보 입력 칸)
  static Widget buildSelectionRow({
    required BuildContext context,
    required String title,
    required String value,
    required Function(String) onSelect,
    required Function(String, Function(String)) selectOption, // ✅ 추가된 매개변수
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          TextButton(
            onPressed: () => selectOption(title, onSelect), // ✅ _selectOption 실행
            child: Text(value, style: const TextStyle(color: Color(0xff1bb881), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }


  /// ✅ **(수정) 헤더를 public 메서드로 변경**
  static Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 45, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xff1bb881)),
            onPressed: () => Navigator.pop(context),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, bottom: 5),
            child: Text(
              '예약하기',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              '병원 예약을 위해 정보를 입력해 주세요.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildAgreementCheckbox({
    required bool isAgreed, // ✅ 현재 동의 상태
    required VoidCallback onToggle, // ✅ 동의 상태 변경 함수
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle, // ✅ 외부에서 전달받은 함수 실행
            child: Icon(
              Icons.check_circle,
              color: isAgreed ? const Color(0xff1bb881) : Colors.grey.shade400, // ✅ 상태에 따라 색상 변경
              size: 24,
            ),
          ),
          const SizedBox(width: 8), // ✅ 아이콘과 텍스트 간격 조정
          const Text(
            '뽀록 이용약관에 동의합니다. (필수)',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ✅ 상단 탭 버튼
  static Widget buildTabBar({
    required bool showPosts,
    required VoidCallback onShowPosts,
    required VoidCallback onShowHospitals,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTabButton(title: "게시글", isActive: showPosts, onTap: onShowPosts),
          const SizedBox(width: 10),
          buildTabButton(title: "병원", isActive: !showPosts, onTap: onShowHospitals),
        ],
      ),
    );
  }

  /// ✅ 개별 탭 버튼
  static Widget buildTabButton({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(title, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  /// ✅ 찜한 게시글 리스트
  static Widget buildPostList({
    required List<Post> favoritePosts,
    required Function(Post) onToggleFavorite,
  }) {
    return ListView.builder(
      itemCount: favoritePosts.length,
      itemBuilder: (context, index) {
        final post = favoritePosts[index];
        return ListTile(
          title: Text(post.title),
          subtitle: Text(post.content, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () => onToggleFavorite(post),
          ),
        );
      },
    );
  }

  /// ✅ 병원 찜 리스트 UI (buildHospitalCard 사용)
  static Widget buildHospitalList({
    required List<Hospital> favoriteHospitals,
    required Function(Hospital) onToggleFavorite,
    required BuildContext context,
  }) {
    return ListView.builder(
      key: ValueKey(favoriteHospitals.length), // ✅ 리스트 길이 기반 Key 추가
      itemCount: favoriteHospitals.length,
      itemBuilder: (context, index) {
        final hospital = favoriteHospitals[index];

        return buildHospitalCard(
          context: context,
          hospital: hospital,
          isFavorite: favoriteHospitals.contains(hospital),
          onFavoriteToggle: () => onToggleFavorite(hospital),
        );
      },
    );
  }

  /// ✅ 병원 카드를 위한 재사용 가능한 위젯
  static Widget buildHospitalCard({
    required BuildContext context,
    required Hospital hospital,
    required VoidCallback onFavoriteToggle,
    required bool isFavorite,
  }) {
    return GestureDetector(
      onTap: () {
        // 병원 상세 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HospitalDetailScreen(hospital: hospital),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 25),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 병원 이미지와 정보 (가로 배치)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                '이미지 없음',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      // 병원 정보 (세로 배치)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    hospital.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.bookmark : Icons.bookmark_border, // ✅ 찜 여부 반영
                                    color: isFavorite ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: onFavoriteToggle, // ✅ 클릭 시 찜 토글
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
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
                                  style: const TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff666666)),
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
                ),
                const SizedBox(height: 12),
                // 전화문의 및 예약하기 버튼 (가로 배치)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            launchUrl(Uri.parse('tel:${hospital.phone}'));
                          },
                          icon: const Icon(Icons.phone, size: 20, color: Color(0xff898d99)),
                          label: const Text('전화문의'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xfff7f7f7),
                            foregroundColor: const Color(0xff898d99),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            textStyle: const TextStyle(fontSize: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReservationScreen(hospital: hospital),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_today, size: 20, color: Colors.white),
                          label: const Text('예약하기'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff1bb881),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ 병원 카드를 위한 재사용 가능한 위젯
  static Widget buildHospitalDTOCard({
    required BuildContext context,
    required HospitalDto hospital,
    required VoidCallback onFavoriteToggle,
    required bool isFavorite,
  }) {
    return GestureDetector(
      onTap: () {
        // 병원 상세 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HospitaldtoDetailScreen(hospital: hospital),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 25),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 병원 이미지와 정보 (가로 배치)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "https://placehold.co/90",
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                '이미지 없음',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      // 병원 정보 (세로 배치)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    hospital.hospitalName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.bookmark : Icons.bookmark_border, // ✅ 찜 여부 반영
                                    color: isFavorite ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: onFavoriteToggle, // ✅ 클릭 시 찜 토글
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Color(0xff1bb881), size: 18),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    hospital.address.fullAddress,
                                    style: const TextStyle(color: Color(0xff8EA0AC), fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  hospital.address.scAddress.toString(),
                                  style: const TextStyle(fontSize: 14, color: Color(0xff666666)),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.star, color: Colors.orange, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  "4.5",
                                  style: const TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff666666)),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '2km',
                                  style: const TextStyle(fontSize: 14, color: Color(0xff898d99)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // 전화문의 및 예약하기 버튼 (가로 배치)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            launchUrl(Uri.parse('tel:${hospital.hospitalPhone}'));
                          },
                          icon: const Icon(Icons.phone, size: 20, color: Color(0xff898d99)),
                          label: const Text('전화문의'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xfff7f7f7),
                            foregroundColor: const Color(0xff898d99),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            textStyle: const TextStyle(fontSize: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DtoReservationScreen(hospital: hospital),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_today, size: 20, color: Colors.white),
                          label: const Text('예약하기'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff1bb881),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
