import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TDeviceTypeItem extends StatelessWidget {
  const TDeviceTypeItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onPressed,
    required this.contentPadding,
  });

  final String title;
  final bool isSelected;
  final EdgeInsets contentPadding;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: contentPadding,
        elevation: 0,
        primary: ColorName.white,
        onPrimary: ColorName.sky300,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: textTheme.bodyMedium),
            ],
          ),
          if (isSelected)
            Assets.icons.tickCircle.svg(
              fit: BoxFit.scaleDown,
              color: ColorName.sky600,
            )
        ],
      ),
    );
  }
}
