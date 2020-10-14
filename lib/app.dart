import 'package:ferryjamku/controllers/auth_controller.dart';
import 'package:ferryjamku/pages/home_page.dart';
import 'package:ferryjamku/pages/login_page.dart';
import 'package:ferryjamku/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  final AuthController authController = Get.put(AuthController()..authCheck());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.authStatus.value == AuthStatus.unauthenticated) {
        return LoginPage();
      } else if (authController.authStatus.value == AuthStatus.authenticated) {
        return HomePage();
      }
      return LoadingWidget();
    });
  }
}
