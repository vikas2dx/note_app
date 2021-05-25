import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubits/CubitState.dart';
import 'package:note_app/cubits/SiginInCubit.dart';
import 'package:note_app/ui/pages/DashboardPage.dart';
import 'package:note_app/ui/resources/AppColor.dart';
import 'package:note_app/ui/resources/AppDimen.dart';
import 'package:note_app/ui/resources/AppFont.dart';
import 'package:note_app/ui/resources/AppStrings.dart';
import 'package:note_app/ui/widgets/CustomButton.dart';
import 'package:note_app/ui/widgets/LoadingWidget.dart';

import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SignInCubit signInCubit = SignInCubit();

  final verticalGap = const SizedBox(
    height: 15,
  );
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var _validateEmail = false;
  var _validatePassword = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          Scaffold(
            appBar: AppBar(title: Text(AppStrings.LOGIN)),
            body: Container(
              margin: const EdgeInsets.all(AppDimen.LAYOUT_MARGIN),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: AppDimen.HORIZONTAL_PADDING_TEXTFIELD,
                          vertical: AppDimen.VERTICAL_PADDING_TEXTFIELD),
                      hintText: AppStrings.HINT_EMAIL,
                      labelText: AppStrings.HINT_EMAIL,
                      errorText:
                          _validateEmail ? 'Email Can\'t Be Empty' : null,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimen.ROUNDED_RADIUS),
                          borderSide:
                              BorderSide(color: AppColor.borderGrey, width: 1)),
                    ),
                    style: TextStyle(fontSize: AppFont.MEDIUM),
                  ),
                  verticalGap,
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: AppDimen.HORIZONTAL_PADDING_TEXTFIELD,
                          vertical: AppDimen.VERTICAL_PADDING_TEXTFIELD),
                      hintText: AppStrings.HINT_PASSWORD,
                      labelText: AppStrings.HINT_PASSWORD,
                      errorText:
                          _validatePassword ? 'Password Can\'t Be Empty' : null,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimen.ROUNDED_RADIUS),
                          borderSide:
                              BorderSide(color: AppColor.borderGrey, width: 1)),
                    ),
                    style: TextStyle(fontSize: AppFont.MEDIUM),
                  ),
                  verticalGap,
                  CustomButton(
                    text: AppStrings.LOGIN,
                    pressedCallBack: () async {
                      setState(() {
                        if (emailController.text.isEmpty) {
                          _validateEmail = true;
                          return;
                        } else {
                          _validateEmail = false;
                        }
                        if (passwordController.text.isEmpty) {
                          _validatePassword = true;
                          return;
                        } else {
                          _validatePassword = false;
                          signInCubit.signInEmail(
                              emailController.text, passwordController.text);
                        }
                      });

                      // signInEmail();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.DONT_HAVE_ACCOUNT),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registerpage()),
                            );
                          },
                          child: Text(
                            AppStrings.REGISTER,
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
          BlocConsumer(
            listener: (context, state) {
              if (state is SuccessState) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardPage(),
                    ));
              } else if (state is FailedState) {}
            },
            cubit: signInCubit,
            builder: (context, state) {
              if (state is LoadingState) {
                return LoadingWidget(true);
              } else if (state is FailedState) {
                return LoadingWidget(false);
              } else if (state is SuccessState) {
                return LoadingWidget(false);
              } else {
                return LoadingWidget(false);
              }
            },
          )
        ],
      ),
    );
  }
}
