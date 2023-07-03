import 'package:flutter/material.dart';
import '../responsiveLayout/responsive.dart';
import '../screens/mobile_login.dart';
import '../screens/tab_login.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResponsiveLayout(
            tabScreenLayout: TabLoginScreen(),
            mobileScreenLayout: MobileLoginScreen(),
          ),),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(
              color: Colors.indigo,
              width: 1.0,
            ),
          ),
          child: Container(
            width: 110.0,
            height: 40.0,
            decoration: const BoxDecoration(
              color: Colors.indigo,
            ),
            child: const Center(
              child: Text(
                'LOGOUT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
