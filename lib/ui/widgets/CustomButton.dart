import 'package:flutter/material.dart';
import 'package:note_app/ui/resources/AppDimen.dart';
import 'package:note_app/ui/resources/AppFont.dart';

class CustomButton extends StatelessWidget {
  String text;
  VoidCallback pressedCallBack;
  CustomButton({this.text,this.pressedCallBack});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        child: Text(text.toUpperCase(),
            style: TextStyle(fontSize: AppFont.MEDIUM)),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: AppDimen.VERTICAL_PADDING_BUTTON)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimen.ROUNDED_RADIUS),
                    side: BorderSide(color: Colors.red)))),
        onPressed: () {
          pressedCallBack.call();
        },
      ),
    );
  }
}
