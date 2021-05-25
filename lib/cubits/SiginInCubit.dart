import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubits/CubitState.dart';
import 'package:note_app/cubits/UICubit.dart';
import 'package:note_app/ui/pages/LoginPage.dart';
import 'package:note_app/utils/PreferencesUtils.dart';

class SignInCubit extends Cubit<CubitState> {
  UICubit<bool> loaderCubit = UICubit<bool>(false);

  SignInCubit() : super(InitialState());

  void signInEmail(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    emit(LoadingState());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential != null) {
        PreferencesUtils().saveLoginDaa(userCredential);
        emit(SuccessState());
      } else {
        emit(FailedState());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(FailedState(message: 'No user found for that email.'));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        emit(FailedState(message: 'Wrong password provided for that user.'));

        print('Wrong password provided for that user.');
      } else {
        emit(FailedState(message: 'Unknown error'));
      }
    }
  }

  Future<void> passwordChanged(String password, BuildContext context) async {
    var user = await FirebaseAuth.instance.currentUser;
    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Successfully changed password");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage(),));
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }
}
