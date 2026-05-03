import 'package:flutter/material.dart';

class LayoutBuilderWidget extends StatelessWidget {
  final bool? isColor;
  final int sections;
  final double width;

  const LayoutBuilderWidget({
    super.key,
    this.isColor,
    required this.sections,
    this.width = 3,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final count = (constraints.constrainWidth() / sections).floor();
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: List.generate(
            count,
            (index) => SizedBox(
              width: width,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isColor == null ? Colors.white : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
