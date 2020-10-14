import 'package:ferryjamku/controllers/auth_controller.dart';
import 'package:ferryjamku/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.find();
  final TextEditingController username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/background.jpg'), fit: BoxFit.cover)),
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('FERRY JAMKU', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: kWhiteColor)),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF8E44AD), Color(0xFF9B59B6)]), borderRadius: BorderRadius.circular(5), boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black.withOpacity(0.25), offset: Offset(2, 2))]),
                child: Column(
                  children: [
                    TextField(
                      controller: username,
                      style: TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        isDense: true,
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.5),
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                        hintText: 'Masukkan Username',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        authController.login(username.text);
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: RaisedButton(
                        onPressed: () {
                          authController.login(username.text);
                        },
                        child: Text('Masuk', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
