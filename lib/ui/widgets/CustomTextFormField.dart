import 'package:flutter/material.dart';
import 'package:note_app/ui/resources/AppColor.dart';
import 'package:note_app/ui/resources/AppDimen.dart';
import 'package:note_app/ui/resources/AppFont.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;


  CustomTextFormField({this.hintText,this.controller});


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
        EdgeInsets.symmetric(horizontal: AppDimen.HORIZONTAL_PADDING_TEXTFIELD,
            vertical: AppDimen.VERTICAL_PADDING_TEXTFIELD),
        hintText: hintText,
        labelText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimen.ROUNDED_RADIUS),
            borderSide: BorderSide(
                color: AppColor.borderGrey, width: 1)),
      ),
      style: TextStyle(fontSize: AppFont.MEDIUM),
    );
  }
}
