import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_app/ui/pages/DashboardPage.dart';
import 'package:note_app/ui/pages/LoginPage.dart';
import 'package:note_app/ui/resources/AppColor.dart';
import 'package:note_app/ui/resources/AppStrings.dart';
import 'package:note_app/ui/widgets/CustomText.dart';
import 'package:note_app/utils/PreferencesUtils.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: AppColor.themeColor,
        child: Center(
          child: CustomText(
            text: AppStrings.APP_NAME,
            color: AppColor.white,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
      Timer(Duration(seconds: 4), () async {
        bool isLogin = await PreferencesUtils().getBool(PreferencesKeys.IS_LOGIN);
        if (isLogin) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DashboardPage()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      });
  }
}
