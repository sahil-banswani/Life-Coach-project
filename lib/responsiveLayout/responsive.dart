import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget tabScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({
    super.key,
    required this.tabScreenLayout,
    required this.mobileScreenLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          //Web Screen
          return tabScreenLayout;
        } else {
          //mobile screen
          return mobileScreenLayout;
        }
      },
    );
  }
}
