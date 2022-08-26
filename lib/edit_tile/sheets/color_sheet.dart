import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class ColorSheet extends StatelessWidget {
  const ColorSheet({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  final Color initialColor;
  final void Function(Color) onColorChanged;

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
              ...colors.map(
                (color) => GestureDetector(
                  onTap: () => onColorChanged(color),
                  child: CircleAvatar(backgroundColor: color, radius: 24),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
