import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class GroupItem extends StatelessWidget {
  const GroupItem({
    super.key,
    required this.group,
    required this.groupNumber,
    required this.deviceNumber,
    required this.onPressed,
  });

  final Group group;
  final int groupNumber;
  final int deviceNumber;
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
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    group.name,
                    style: textTheme.bodyLarge!.copyWith(
                      color: ColorName.neural700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatItem(
                  unit: 'group',
                  number: groupNumber,
                  image: Assets.icons.global,
                ),
                const SizedBox(width: 14),
                _StatItem(
                  unit: 'device',
                  number: deviceNumber,
                  image: Assets.icons.global,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.unit,
    required this.number,
    required this.image,
  });

  final String unit;
  final int number;
  final SvgGenImage image;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        image.svg(
          fit: BoxFit.scaleDown,
          color: ColorName.neural600,
          height: 18,
          width: 18,
        ),
        const SizedBox(width: 4),
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
