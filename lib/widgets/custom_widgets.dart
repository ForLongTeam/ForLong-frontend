import 'package:flutter/material.dart';

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
}
