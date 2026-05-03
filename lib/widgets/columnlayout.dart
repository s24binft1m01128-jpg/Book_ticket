import 'package:bookticket/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Columnlayout extends StatelessWidget {
  final CrossAxisAlignment alignment;
  final String firstText;
  final String secondText;
  final bool? isColor;

  const Columnlayout({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.alignment,
    required this.isColor,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isColor == null ? Styles.textcolor : Colors.white;
    final supporting = isColor == null
        ? Styles.mutedTextColor
        : Colors.white.withValues(alpha: 0.78);

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          firstText,
          style: Styles.headlineStyle3.copyWith(color: foreground),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Gap(5),
        Text(
          secondText,
          style: Styles.headlineStyle4.copyWith(color: supporting),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
