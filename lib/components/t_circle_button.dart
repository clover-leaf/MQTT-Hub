import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TCircleButton extends StatelessWidget {
  const TCircleButton({
    super.key,
    required this.picture,
    required this.onPressed,
    this.enabled = true,
    this.primaryColor = ColorName.white,
    this.onPrimaryColor = ColorName.sky300,
  });

  final Widget picture;
  final bool enabled;
  final void Function() onPressed;
  final Color primaryColor;
  final Color onPrimaryColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        shadowColor: Colors.transparent,
        shape: const CircleBorder(),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: picture,
      ),
    );
  }
}
