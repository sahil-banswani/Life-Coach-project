import 'package:flutter/material.dart';

class TabProfileBar extends StatelessWidget {
  const TabProfileBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width * 0.25,
      height: 20,
      color: Colors.grey[700],
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset('assets/images/logo.png')),
        ],
      ),
    );
  }
}
