import 'package:flutter/material.dart';
import 'package:forlong/services/api_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../models/hospital.dart';
<<<<<<< Updated upstream:lib/screens/reservation_screen.dart
import '../widgets/hospital_info_card.dart';
import 'hospital_search_screen.dart';
=======
import '../../widgets/hospital_info_card.dart';
import '../../widgets/custom_widgets.dart'; // ✅ UI 위젯 가져오기
>>>>>>> Stashed changes:lib/screens/hospital/reservation_screen.dart

class ReservationScreen extends StatefulWidget {
  final Hospital hospital;

  const ReservationScreen({super.key, required this.hospital});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String _selectedPet = '선택하기 >';
  String _selectedDate = '선택하기 >';
  String _selectedTime = '선택하기 >';
  bool _isAgreed = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _availableTimesForSelectedDate = [];

  void _selectOption(String type, Function(String) onSelect) async {
    if (type == '예약일') {
      _showDatePicker();
      return;
    } else if (type == '예약시간') {
      _showTimePicker();
      return;
    }

    String? result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('$type 선택'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, '$type A'),
            child: Text('$type A'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, '$type B'),
            child: Text('$type B'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        onSelect(result);
      });
    }
  }

  void _showDatePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon:
                            Icon(Icons.chevron_left, color: Color(0xff1bb881)),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(
                                _focusedDay.year, _focusedDay.month - 1, 1);
                          });
                        },
                      ),
                      Text(
                        DateFormat('yyyy년 MM월').format(_focusedDay),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1bb881)),
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.chevron_right, color: Color(0xff1bb881)),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(
                                _focusedDay.year, _focusedDay.month + 1, 1);
                          });
                        },
                      ),
                    ],
                  ),
                  TableCalendar(
                    locale: 'ko_KR',
                    // 한국어 로케일 설정
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: CalendarFormat.month,
                    headerVisible: false,
                    // 상단 기본 헤더 제거
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });
                      _updateAvailableTimes(); // ✅ 선택한 날짜의 예약 가능 시간 업데이트
                    },
                    calendarBuilders: CalendarBuilders(
                      dowBuilder: (context, day) {
                        final text = DateFormat.E('ko_KR').format(day);
                        return Center(
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: day.weekday == DateTime.sunday
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                        );
                      },
                      defaultBuilder: (context, day, focusedDay) {
                        if (day.weekday == DateTime.sunday) {
                          return Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      weekendStyle:
                          TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(),
                      isTodayHighlighted: false,
                      // 현재 날짜 스타일 제거
                      selectedDecoration: BoxDecoration(
                        color: Color(0xff1bb881),
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle:
                          TextStyle(color: Colors.black, fontSize: 16),
                      // 기본 날짜 텍스트 스타일
                      outsideTextStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0), // 하단 여백 추가
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedDay != null) {
                          setState(() {
                            _selectedDate = DateFormat('yyyy년 MM월 dd일')
                                .format(_selectedDay!);
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff1bb881),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        '${DateFormat('MM월 dd일').format(_selectedDay ?? DateTime.now())} 선택하기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // 캘린더가 닫힌 후 선택된 날짜를 화면에 업데이트
      if (_selectedDay != null) {
        setState(() {
          _selectedDate = DateFormat('yyyy년 MM월 dd일').format(_selectedDay!);
        });
      }
    });
  }

  void _updateAvailableTimes() {
    if (_selectedDay == null) return;

    String selectedDateStr = DateFormat('yyyy-MM-dd').format(_selectedDay!);

    setState(() {
      _availableTimesForSelectedDate = widget.hospital.availableTimes
          .where((timeSlot) => timeSlot['date'] == selectedDateStr)
          .toList();
    });
  }

  /// 시간 선택 모달
  void _showTimePicker() async {
    showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String? tempSelectedTime;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '예약 시간',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (_availableTimesForSelectedDate.isEmpty)
                    const Text("예약 가능한 시간이 없습니다.",
                        style: TextStyle(color: Colors.grey))
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: _availableTimesForSelectedDate.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.5,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        var time =
                            _availableTimesForSelectedDate[index]['time'];
                        bool available =
                            _availableTimesForSelectedDate[index]['available'];
                        bool isSelected = tempSelectedTime == time;

                        return GestureDetector(
                          onTap: available
                              ? () => setState(() => tempSelectedTime = time)
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xff1bb881).withOpacity(0.2)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                      color: available
                                          ? (isSelected
                                              ? const Color(0xff1bb881)
                                              : const Color(0xff898d99))
                                          : const Color(0xffe1e1e1),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: isSelected
                                      ? const Color(0xff1bb881)
                                      : Colors.grey.shade400,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: tempSelectedTime != null
                        ? () {
                            Navigator.pop(context, tempSelectedTime);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tempSelectedTime != null
                          ? const Color(0xff1bb881)
                          : Colors.grey,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      tempSelectedTime != null
                          ? '$tempSelectedTime 선택하기'
                          : '시간 선택하기',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((selectedTime) {
      if (selectedTime != null) {
        setState(() {
          _selectedTime = selectedTime;
        });
      }
    });
  }

  /// ✅ 예약 요청
  void _submitReservation() async {
    if (!_isAgreed || _selectedDate == '선택하기 >' || _selectedTime == '선택하기 >')
      return;

    try {
      await ApiService.bookAppointment(
        hospitalId: widget.hospital.name,
        date: _selectedDate,
        time: _selectedTime,
        pet: _selectedPet,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('예약이 완료되었습니다.')),
      );
      Navigator.pop(context); // ✅ 예약 후 화면 닫기
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('예약 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomWidgets.buildHeader(context), // ✅ UI 위젯 호출
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HospitalInfoCard(hospital: widget.hospital),
                  CustomWidgets.buildReservationSection(
                    context: context,
                    selectedPet: _selectedPet,
                    selectedDate: _selectedDate,
                    selectedTime: _selectedTime,
                    onPetSelect: (value) => setState(() => _selectedPet = value),
                    onDateSelect: (value) => setState(() => _selectedDate = value),
                    onTimeSelect: (value) => setState(() => _selectedTime = value),
                    selectOption: _selectOption, // ✅ _selectOption 전달
                  ),
                  CustomWidgets.buildAgreementCheckbox(
                    isAgreed: _isAgreed,
                    onToggle: () => setState(() => _isAgreed = !_isAgreed),
                  ),
                ],
              ),
            ),
          ),
          SafeArea( // ✅ 버튼이 화면 아래에 고정됨
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // 좌우 패딩 추가
              child: Align(
                alignment: Alignment.bottomCenter, // ✅ 버튼을 화면 아래로 정렬
                child: CustomWidgets.buildBottomButton(
                  isAgreed: _isAgreed,
                  onPressed: _submitReservation,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
