import 'package:flutter/material.dart';

class ThickContainer extends StatelessWidget {
  final bool? isColor;

  const ThickContainer({super.key, this.isColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 11,
      width: 11,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 3,
          color: isColor == null ? Colors.white : const Color(0xFF8FB4FF),
        ),
      ),
    );
  }
}
