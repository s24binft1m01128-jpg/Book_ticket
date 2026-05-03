import 'package:bookticket/utils/app_styles.dart';
import 'package:flutter/material.dart';

class AppTicketTabs extends StatelessWidget {
  final String firstTabs;
  final String secondTabs;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  const AppTicketTabs({
    super.key,
    required this.firstTabs,
    required this.secondTabs,
    this.selectedIndex = 0,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final labels = [firstTabs, secondTabs];

    return Container(
      height: 52,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Styles.ticketTabColor,
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged?.call(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: isSelected ? Colors.white : Colors.transparent,
                  boxShadow: isSelected ? Styles.softShadow : null,
                ),
                child: Text(
                  labels[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.textStyle.copyWith(
                    color: isSelected
                        ? Styles.primarycolor
                        : Styles.mutedTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
