import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
   bool isLoading;

  LoadingWidget(this.isLoading);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container();
    }
  }
}
