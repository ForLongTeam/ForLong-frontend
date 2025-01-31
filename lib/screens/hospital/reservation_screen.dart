import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../models/hospital.dart';
import '../../widgets/hospital_info_card.dart';
import 'hospital_search_screen.dart';

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

  void _selectOption(String type, Function(String) onSelect) async {
    if (type == '예약일') {
      _showDatePicker();
      return;
    }
    else if(type == '예약시간'){
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
                        icon: Icon(Icons.chevron_left, color: Color(0xff1bb881)),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
                          });
                        },
                      ),
                      Text(
                        DateFormat('yyyy년 MM월').format(_focusedDay),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff1bb881)),
                      ),
                      IconButton(
                        icon: Icon(Icons.chevron_right, color: Color(0xff1bb881)),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
                          });
                        },
                      ),
                    ],
                  ),
                  TableCalendar(
                    locale: 'ko_KR',  // 한국어 로케일 설정
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: CalendarFormat.month,
                    headerVisible: false,  // 상단 기본 헤더 제거
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
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
                              color: day.weekday == DateTime.sunday ? Colors.red : Colors.black,
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
                      weekdayStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                      weekendStyle: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(),
                      isTodayHighlighted : false, // 현재 날짜 스타일 제거
                      selectedDecoration: BoxDecoration(
                        color: Color(0xff1bb881),
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: TextStyle(color: Colors.black, fontSize: 16),  // 기본 날짜 텍스트 스타일
                      outsideTextStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),  // 하단 여백 추가
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedDay != null) {
                          setState(() {
                            _selectedDate = DateFormat('yyyy년 MM월 dd일').format(_selectedDay!);
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff1bb881),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  void _showTimePicker() async {
    List<Map<String, dynamic>> times = [
      {'time': '10:00', 'available': true},
      {'time': '11:00', 'available': true},
      {'time': '13:00', 'available': true},
      {'time': '14:00', 'available': false},
      {'time': '15:00', 'available': true},
      {'time': '16:00', 'available': true},
      {'time': '17:00', 'available': true},
      {'time': '18:00', 'available': true},
      {'time': '19:00', 'available': true},
    ];

    showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String? tempSelectedTime = '';

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 14.0), // 왼쪽 패딩 추가
                        child: Text(
                          '예약 시간',
                          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            tempSelectedTime = null;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: times.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      var time = times[index]['time'];
                      bool available = times[index]['available'];
                      bool isSelected = tempSelectedTime == time;

                      return GestureDetector(
                        onTap: available ? () => setState(() => tempSelectedTime = time) : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xff1bb881).withOpacity(0.2) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    color: available
                                        ? (isSelected ? Color(0xff1bb881) : Color(0xff898d99))
                                        : Color(0xffe1e1e1),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.check_circle,
                                color: isSelected ? Color(0xff1bb881) : Colors.grey.shade400, // 선택 여부에 따른 색상
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
                      Navigator.pop(context, tempSelectedTime); // 모달 닫으면서 선택 시간 전달
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tempSelectedTime != null ? Color(0xff1bb881) : Colors.grey,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      tempSelectedTime != null ? '$tempSelectedTime 선택하기' : '시간 선택하기',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HospitalInfoCard(hospital: widget.hospital),
                  const SizedBox(height: 16),
                  _buildReservationSection(),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 50, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xff1bb881)),
            onPressed: () => Navigator.pop(context),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 14, top: 10),
            child: Text(
              '예약하기',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Text(
              '병원 예약을 위해 정보를 입력해 주세요.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '예약하기',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildSelectionRow('반려동물', _selectedPet, (value) => _selectedPet = value),
          _buildSelectionRow('예약일', _selectedDate, (value) => _selectedDate = value),
          _buildSelectionRow('예약시간', _selectedTime, (value) => _selectedTime = value),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isAgreed = !_isAgreed;
                  });
                },
                child: Icon(
                  Icons.check_circle,
                  color: _isAgreed ? Color(0xff1bb881) : Colors.grey.shade400, // 선택 여부에 따른 색상
                  size: 24,
                ),
              ),
              const SizedBox(width: 8), // 아이콘과 텍스트 간격 조정
              const Text(
                '뽀록 이용약관에 동의합니다. (필수)',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionRow(String title, String value, Function(String) onSelect) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          TextButton(
            onPressed: () => _selectOption(title, onSelect),
            child: Text(value, style: const TextStyle(color: Color(0xff1bb881), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
  Widget _buildBottomButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ElevatedButton(
          onPressed: _isAgreed ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HospitalSearchScreen(),
              ),
            );
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isAgreed ? Color(0xff1bb881) : Colors.grey,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('예약하기', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}

