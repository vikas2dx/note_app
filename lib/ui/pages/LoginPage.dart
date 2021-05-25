import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubits/CubitState.dart';
import 'package:note_app/cubits/SiginInCubit.dart';
import 'package:note_app/ui/pages/DashboardPage.dart';
import 'package:note_app/ui/resources/AppDimen.dart';
import 'package:note_app/ui/resources/AppStrings.dart';
import 'package:note_app/ui/widgets/CustomButton.dart';
import 'package:note_app/ui/widgets/CustomTextFormField.dart';
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
                    text: AppStrings.LOGIN,
                    pressedCallBack: () async {
                      signInCubit.signInEmail(
                          emailController.text, passwordController.text);
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
