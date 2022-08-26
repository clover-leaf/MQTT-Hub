import 'package:bee/components/t_secondary_button.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class IconColorSheet extends StatefulWidget {
  const IconColorSheet({
    super.key,
    required this.initialColor,
    required this.initialIcon,
    required this.onSaved,
  });

  final Color? initialColor;
  final SvgGenImage? initialIcon;
  final void Function(Map<String, dynamic>) onSaved;

  @override
  State<IconColorSheet> createState() => _IconColorSheetState();
}

class _IconColorSheetState extends State<IconColorSheet> {
  late Color _color;
  late SvgGenImage _icon;

  @override
  void initState() {
    super.initState();
    _color = widget.initialColor ?? ColorName.iColor1;
    _icon = widget.initialIcon ?? Assets.icons.sun;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final colors = [
      ColorName.iColor1,
      ColorName.iColor2,
      ColorName.iColor3,
      ColorName.iColor4,
      ColorName.iColor5,
      ColorName.iColor6,
      ColorName.iColor7,
      ColorName.iColor8,
      ColorName.iColor9,
      ColorName.iColor10,
      ColorName.iColor11,
      ColorName.iColor12,
    ];

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 64),
              CircleAvatar(
                radius: 40,
                backgroundColor: ColorName.darkWhite,
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: _color,
                  child: _icon.svg(
                    color: ColorName.white,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TSecondaryButton(
                  label: 'SAVE',
                  onPressed: () =>
                      widget.onSaved({'color': _color, 'icon': _icon}),
                  enabled: true,
                  textStyle: textTheme.labelLarge!.copyWith(
                    color: ColorName.sky500,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.1,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              )
            ],
          ),
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
              ...colors.map(
                (color) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _color = color;
                    });
                  },
                  child: CircleAvatar(backgroundColor: color, radius: 24),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
            child: Text(
              'Icon',
              style: textTheme.titleSmall,
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...icons.map(
                (icon) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _icon = icon;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: ColorName.darkWhite,
                    radius: 24,
                    child: icon.svg(
                      color: ColorName.darkBlue,
                      fit: BoxFit.scaleDown,
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
