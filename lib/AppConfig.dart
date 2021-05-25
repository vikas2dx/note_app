import 'package:firebase_core/firebase_core.dart';

class AppConfig {
  static AppConfig _appConfig = AppConfig._private();


  factory AppConfig() {
    return _appConfig;
  }
  AppConfig._private();

  Future<void> init() async
  {
    await Firebase.initializeApp();

  }


}
