import 'package:flutter/material.dart';
import 'package:gp_screen/Pages/loginPage/ThePage/Forgetpasswordscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ForgotPasswordScreen(),
    );
  }
}
