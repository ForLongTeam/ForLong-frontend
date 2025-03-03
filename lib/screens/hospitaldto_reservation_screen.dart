import 'package:flutter/material.dart';
import 'package:forlong/models/hospitaldto.dart';
import 'package:forlong/widgets/hospitaldto_info_card.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../widgets/custom_widgets.dart'; // ✅ UI 위젯 가져오기

class DtoReservationScreen extends StatefulWidget {
  final HospitalDto hospital;

  const DtoReservationScreen({super.key, required this.hospital});

  @override
  _DtoReservationScreenState createState() => _DtoReservationScreenState(); // ✅ 클래스명 일치
}


class _DtoReservationScreenState extends State<DtoReservationScreen> {
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
                    onPageChanged: (focusedDay) { // ✅ 스크롤 시 자동 업데이트
                      setState(() {
                        _focusedDay = focusedDay;
                      });
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

    // ✅ DB에 종료 시간이 없으면 기본 종료 시간(18:00) 설정
    String openTimeStr = widget.hospital.formattedTime;
    String closeTimeStr = "18:00"; // 기본 종료 시간

    DateTime openTime = DateFormat("HH:mm").parse(openTimeStr);
    DateTime closeTime = DateFormat("HH:mm").parse(closeTimeStr);

    List<Map<String, dynamic>> generatedTimes = [];

    bool isToday = isSameDay(_selectedDay!, DateTime.now());
    DateTime now = DateTime.now();

    for (DateTime time = openTime;
    time.isBefore(closeTime);
    time = time.add(Duration(minutes: 30))) {

      String timeStr = DateFormat("HH:mm").format(time);

      bool isUnavailable = widget.hospital.vets.any((vet) =>
          vet.unavailableDates.any((unavailable) =>
          unavailable.notDate == "$selectedDateStr $timeStr"
          )
      );

      bool isPastTime = isToday && time.isBefore(now);

      generatedTimes.add({
        "time": timeStr,
        "available": !isUnavailable && !isPastTime
      });
    }

    setState(() {
      _availableTimesForSelectedDate = generatedTimes;
    });
  }



  void _showTimePicker() async {
    showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String? tempSelectedTime = _selectedTime; // ✅ 초기값을 현재 선택된 시간으로 설정

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Center( // ✅ 텍스트를 중앙 정렬
                          child: Padding(
                            padding: const EdgeInsets.only(left: 35.0),
                            child: Text(
                              '예약 시간',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.grey.shade400), // ✅ 새로고침 아이콘
                        onPressed: () {
                          _updateAvailableTimes(); // ✅ 예약 가능한 시간 새로고침
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_availableTimesForSelectedDate.isEmpty)
                    const Text("예약 가능한 시간이 없습니다.", style: TextStyle(color: Colors.grey))
                  else
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        //physics: NeverScrollableScrollPhysics(), // ✅ 내부에서 스크롤이 필요하지 않으면 비활성화
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // ✅ 2개씩 배치
                          crossAxisSpacing: 10, // ✅ 가로 간격 조정
                          mainAxisSpacing: 10, // ✅ 세로 간격 조정
                          childAspectRatio: 3.5, // ✅ 아이템 크기 조절 (가로/세로 비율)
                        ),
                        itemCount: _availableTimesForSelectedDate.length,
                        itemBuilder: (context, index) {
                          var time = _availableTimesForSelectedDate[index]['time'];
                          bool available = _availableTimesForSelectedDate[index]['available'];
                          bool isSelected = tempSelectedTime == time;
                      
                          return GestureDetector(
                            onTap: available
                                ? () {
                              setState(() {
                                if (tempSelectedTime == time) {
                                  tempSelectedTime = '선택하기 >'; // ✅ 이미 선택된 걸 다시 누르면 선택 해제
                                } else {
                                  tempSelectedTime = time; // ✅ 새로운 시간 선택
                                }
                              });
                            }
                                : null,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
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
                                        fontSize: 18,
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
                    ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ElevatedButton(
                      onPressed: tempSelectedTime != null
                          ? () {
                        Navigator.pop(context, tempSelectedTime);
                      }
                          : null, // ✅ 선택된 시간이 없으면 버튼 비활성화
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
    if (!_isAgreed || _selectedDate == '선택하기 >' || _selectedTime == '선택하기 >') return;
    Navigator.pop(context); // ✅ 예약 후 화면 닫기
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
                  HospitalDTOInfoCard(hospital: widget.hospital),
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
