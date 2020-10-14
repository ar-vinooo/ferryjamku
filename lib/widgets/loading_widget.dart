import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9B59B6),
      body: Center(
        child: SpinKitChasingDots(
          color: Colors.white,
        ),
      ),
    );
  }
}
