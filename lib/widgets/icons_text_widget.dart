import 'package:bookticket/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppIconText extends StatelessWidget {
  final IconData icons;
  final String text;
  final String? label;
  final VoidCallback? onTap;

  const AppIconText({
    super.key,
    required this.icons,
    required this.text,
    this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Styles.surfaceColor,
      borderRadius: BorderRadius.circular(Styles.smallRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Styles.smallRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Styles.smallRadius),
            border: Border.all(color: Styles.lineColor),
          ),
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: Styles.primarycolor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icons,
                  color: Styles.primarycolor,
                  size: 21,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (label != null)
                      Text(
                        label!,
                        style: Styles.headlineStyle4.copyWith(fontSize: 12),
                      ),
                    Text(
                      text,
                      style: Styles.textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
