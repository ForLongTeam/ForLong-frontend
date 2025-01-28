import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectDateTimeScreen extends StatefulWidget {
  @override
  _SelectDateTimeScreenState createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay(hour: 16, minute: 0);

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    ) ?? _selectedDate;

    setState(() {
      _selectedDate = picked;
    });
  }

  Future<void> _selectTime() async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    ) ?? _selectedTime;

    setState(() {
      _selectedTime = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('예약하기')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('예약 날짜: ${DateFormat('yyyy년 MM월 dd일').format(_selectedDate)}'),
            ElevatedButton(
              onPressed: _selectDate,
              child: Text('날짜 선택하기'),
            ),
            SizedBox(height: 16),
            Text('예약 시간: ${_selectedTime.format(context)}'),
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('시간 선택하기'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // 예약 확인 및 처리 로직
              },
              child: Text('예약하기'),
            ),
          ],
        ),
      ),
    );
  }
}
