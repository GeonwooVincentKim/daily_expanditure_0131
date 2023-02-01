import 'package:daily_expanditure_0131/shared/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final double size;
  
  const CustomCircleAvatar({super.key, required this.backgroundColor, required this.icon, required this.iconColor, required this.size});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: backgroundColor,
      child: ClipOval(
        child: Icon(icon, color: iconColor, size: size)
      ),
    );
  }
}