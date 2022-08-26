import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class IconSheet extends StatelessWidget {
  const IconSheet({
    super.key,
    required this.initialIcon,
    required this.onIconChanged,
  });

  final SvgGenImage initialIcon;
  final void Function(SvgGenImage) onIconChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // list icon
    final icons = [
      Assets.icons.icon,
      Assets.icons.sun,
      Assets.icons.moon,
      Assets.icons.cloud,
      Assets.icons.wind,
      Assets.icons.snow,
      Assets.icons.star,
      Assets.icons.heart,
      Assets.icons.flash,
      Assets.icons.lamp,
      Assets.icons.lampCharge,
      Assets.icons.batteryCharging,
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      decoration: const BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Color',
              style: textTheme.titleSmall,
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...icons.map(
                (icon) => GestureDetector(
                  onTap: () => onIconChanged(icon),
                  child: CircleAvatar(
                    backgroundColor: ColorName.neural300,
                    radius: 24,
                    child: icon.svg(
                      fit: BoxFit.scaleDown,
                      color: ColorName.neural700,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
