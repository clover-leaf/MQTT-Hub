import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class ProjectItem extends StatelessWidget {
  const ProjectItem({
    super.key,
    required this.project,
    required this.dashboardNumber,
    required this.brokerNumber,
    required this.userNumber,
    required this.onPressed,
  });

  final Project project;
  final int dashboardNumber;
  final int brokerNumber;
  final int userNumber;
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
            Text(
              project.name,
              style: textTheme.bodyLarge!.copyWith(
                color: ColorName.neural700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatItem(
                  unit: 'broker',
                  number: brokerNumber,
                  image: Assets.icons.airdrop,
                ),
                const SizedBox(width: 14),
                _StatItem(
                  unit: 'dashboard',
                  number: dashboardNumber,
                  image: Assets.icons.presentionChart,
                ),
                const SizedBox(width: 14),
                _StatItem(
                  unit: 'user',
                  number: userNumber,
                  image: Assets.icons.profile2user,
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
