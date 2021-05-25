import 'package:flutter/material.dart';
import 'package:note_app/ui/resources/AppColor.dart';
import 'package:note_app/ui/resources/AppFont.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  var fontStyle, fontWeight;
  Color color;

  CustomText({
    this.text,
    this.fontSize = AppFont.MEDIUM,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.normal,
    this.color = AppColor.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontStyle: fontStyle,
          fontWeight: fontWeight),
    );
  }
}
