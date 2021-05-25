import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/ui/pages/DashboardPage.dart';
import 'package:note_app/ui/resources/AppDimen.dart';
import 'package:note_app/ui/resources/AppStrings.dart';
import 'package:note_app/ui/widgets/CustomButton.dart';
import 'package:note_app/ui/widgets/CustomTextFormField.dart';

import 'LoginPage.dart';

class Registerpage extends StatefulWidget {
  @override
  _RegisterpageState createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final verticalGap = const SizedBox(
    height: 15,
  );
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(AppStrings.REGISTER)),
        body: Container(
          margin: const EdgeInsets.all(AppDimen.LAYOUT_MARGIN),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFormField(
                hintText: AppStrings.HINT_EMAIL,
                controller: emailController,
              ),
              verticalGap,
              CustomTextFormField(
                hintText: AppStrings.HINT_PASSWORD,
                controller: passwordController,
              ),
              verticalGap,
              CustomButton(
                text: AppStrings.REGISTER,
                pressedCallBack: () {
                  registerUser();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppStrings.ALREADY_REGISTER),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        AppStrings.LOGIN,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ))
        .user;
    if (user != null) {
      print("Email ${user.email}");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
    }

}
