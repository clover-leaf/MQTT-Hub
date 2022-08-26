import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TValueBox extends StatelessWidget {
  const TValueBox({
    super.key,
    required this.label,
    required this.text,
    required this.prefix,
    required this.onTapped,
    this.enabled = true,
    this.rightTitleButton,
  });

  final String label;
  final String text;
  final SvgPicture prefix;
  final bool enabled;
  final void Function() onTapped;
  final Widget? rightTitleButton;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (rightTitleButton != null) rightTitleButton!
            ],
          ),
        ),
        GestureDetector(
          onTap: enabled ? onTapped : () {},
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: ColorName.gray),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 12, 8),
                  child: prefix,
                ),
                Text(text, style: textTheme.labelLarge)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
