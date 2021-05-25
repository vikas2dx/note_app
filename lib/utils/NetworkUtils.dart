import 'package:connectivity/connectivity.dart';

class NetworkUtils {
  static Future<bool> isInternetAvailable() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if(connectivityResult == ConnectivityResult.none){
      return false;
    }
    return true;
  }
}
