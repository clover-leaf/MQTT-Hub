import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class AttributeItem extends StatelessWidget {
  const AttributeItem({
    super.key,
    required this.attribute,
    required this.onPressed,
  });

  final Attribute attribute;
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
              attribute.name,
              style: textTheme.bodyLarge!.copyWith(
                color: ColorName.neural700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatItem(
                  label: attribute.jsonPath,
                  image: Assets.icons.codeCircle,
                ),
                const SizedBox(width: 8),
                _StatItem(
                  label: attribute.unit ?? 'N/A',
                  image: Assets.icons.languageSquare,
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
    required this.label,
    required this.image,
  });

  final String label;
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
          label,
          style: textTheme.labelMedium!.copyWith(color: ColorName.sky600),
        ),
      ],
    );
  }
}
