import 'package:flutter/material.dart';
import 'package:life_coach/responsiveLayout/responsive.dart';
import 'package:life_coach/screens/mobile_login.dart';
import 'package:life_coach/screens/tab_login.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: ResponsiveLayout(
        tabScreenLayout: TabLoginScreen(),
        mobileScreenLayout: MobileLoginScreen(),
      ),
    );
  }
}
