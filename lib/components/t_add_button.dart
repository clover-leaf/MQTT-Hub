import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TAddButton extends StatelessWidget {
  const TAddButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.textStyle,
  });

  final String label;
  final bool enabled;
  final void Function() onPressed;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: Colors.transparent,
        onPrimary: ColorName.darkBlue,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      onPressed: () {
        if (enabled) {
          onPressed();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Assets.icons.add
                  .svg(color: ColorName.darkBlue, fit: BoxFit.scaleDown),
            ),
            Text(
              label,
              style: textStyle ??
                  textTheme.labelMedium!.copyWith(
                    color: ColorName.sky500,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.1,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
