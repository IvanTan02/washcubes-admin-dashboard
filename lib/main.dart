import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:washcubes_admindashboard/src/features/operator/screens/login/operator_login_page.dart';
import 'package:washcubes_admindashboard/src/utilities/theme/theme.dart';

void main() {
  Get.put(MenuController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Operator Website',
      debugShowCheckedModeBanner: false,
      theme: CAppTheme.lightTheme,
      home: const OperatorLoginPage(),
    );
  }
}
