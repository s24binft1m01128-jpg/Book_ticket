import 'package:bookticket/utils/app_styles.dart';
import 'package:flutter/material.dart';

class DoubleTextWidget extends StatelessWidget {
  final String bigtext;
  final String smalltext;
  final VoidCallback? onTap;

  const DoubleTextWidget({
    super.key,
    required this.bigtext,
    required this.smalltext,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            bigtext,
            style: Styles.headlineStyle2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: Styles.primarycolor,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            minimumSize: const Size(64, 40),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            smalltext,
            style: Styles.textStyle.copyWith(color: Styles.primarycolor),
          ),
        ),
      ],
    );
  }
}
