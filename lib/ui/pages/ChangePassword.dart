import 'package:flutter/material.dart';
import 'package:note_app/cubits/SiginInCubit.dart';
import 'package:note_app/ui/resources/AppColor.dart';
import 'package:note_app/ui/resources/AppDimen.dart';
import 'package:note_app/ui/resources/AppFont.dart';
import 'package:note_app/ui/resources/AppStrings.dart';
import 'package:note_app/ui/widgets/CustomButton.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  final SignInCubit signInCubit = SignInCubit();

  var _validatePassword = false;

  var verticalGap = SizedBox(
    height: 10,
  );

  var _validatePasswordConfirm = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.CHANGE_PASSWORD),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(AppDimen.LAYOUT_MARGIN),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: AppDimen.HORIZONTAL_PADDING_TEXTFIELD,
                      vertical: AppDimen.VERTICAL_PADDING_TEXTFIELD),
                  hintText: AppStrings.CONFIRM_PASSWORD,
                  labelText: AppStrings.CONFIRM_PASSWORD,
                  errorText: _validatePasswordConfirm
                      ? 'Confirm Password Can\'t Be Empty'
                      : null,
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
                text: AppStrings.UPDATE_PASSWORD,
                pressedCallBack: () async {
                  setState(() {
                    if (passwordController.text.isEmpty) {
                      _validatePassword = true;
                      return;
                    } else {
                      _validatePassword = false;
                    }
                    if (confirmPasswordController.text.isEmpty) {
                      _validatePasswordConfirm = true;
                      return;
                    } else {
                      _validatePassword = false;
                    }
                  });
                  if (passwordController.text ==
                      confirmPasswordController.text) {
                    signInCubit.passwordChanged(
                        passwordController.text, context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
