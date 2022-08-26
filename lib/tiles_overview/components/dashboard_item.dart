import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  const DashboardItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onPressed,
  });

  final String title;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: Colors.transparent,
        onPrimary: ColorName.sky300,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 4,
              color: isSelected ? ColorName.sky600 : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          title.toUpperCase(),
          style: textTheme.bodyMedium!.copyWith(
            color: isSelected ? ColorName.sky700 : ColorName.neural500,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.02,
          ),
        ),
      ),
    );
  }
}
