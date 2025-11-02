import 'package:flutter/material.dart';

Widget buildSection({
  required String title,
  required List<Widget> children,
  Color backgroundColor = Colors.white,
}) {
  return Container(
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        ...children,
      ],
    ),
  );
}
