import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TSecondaryButton extends StatelessWidget {
  const TSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.enabled,
    this.textStyle,
    this.padding,
  });

  final String label;
  final bool enabled;
  final void Function() onPressed;
  final TextStyle? textStyle;
  final EdgeInsets? padding;

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: textStyle ??
              textTheme.labelMedium!.copyWith(
                color: ColorName.sky400,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
        ),
      ),
    );
  }
}
