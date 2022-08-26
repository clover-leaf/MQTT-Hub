import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class OptionItem extends StatelessWidget {
  const OptionItem({
    super.key,
    required this.title,
    required this.number,
    required this.unit,
    required this.onPressed,
  });

  final String title;
  final int number;
  final String unit;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.sky100,
        onPrimary: ColorName.sky300,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 28, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyLarge!.copyWith(
                    color: ColorName.neural700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                _FooterItem(number: number, unit: unit)
              ],
            ),
            Assets.icons.arrowRight
                .svg(fit: BoxFit.scaleDown, color: ColorName.neural700)
          ],
        ),
      ),
    );
  }
}

class _FooterItem extends StatelessWidget {
  const _FooterItem({
    required this.number,
    required this.unit,
  });

  final int number;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          '$number ',
          style: textTheme.labelMedium!.copyWith(color: ColorName.sky600),
        ),
        Text(
          number > 1 ? '${unit}s' : unit,
          style: textTheme.labelMedium!.copyWith(color: ColorName.sky600),
        ),
      ],
    );
  }
}
