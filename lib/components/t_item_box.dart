import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TItemBox extends StatelessWidget {
  const TItemBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.prefix,
    required this.postfix,
    required this.onPressed,
    required this.enabled,
  });

  final String title;
  final String? subtitle;
  final Widget? prefix;
  final Widget? postfix;
  final bool enabled;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.white,
        onPrimary: ColorName.sky300,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: ColorName.gray),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            if (prefix != null) prefix!,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.labelLarge),
                  if (subtitle != null)
                    Text(subtitle!, style: textTheme.labelSmall),
                ],
              ),
            ),
            if (postfix != null) postfix!,
          ],
        ),
      ),
    );
  }
}
