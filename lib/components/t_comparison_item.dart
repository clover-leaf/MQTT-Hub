import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class TComparisonItem extends StatelessWidget {
  const TComparisonItem({
    super.key,
    required this.comparison,
    required this.onPressed,
  });

  final Comparison comparison;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    late SvgGenImage picture;
    switch (comparison) {
      case Comparison.g:
        picture = Assets.icons.arrowRight2;
        break;
      case Comparison.geq:
        picture = Assets.icons.arrowRight3;
        break;
      case Comparison.eq:
        picture = Assets.icons.arrowSwapHorizontal;
        break;
      case Comparison.leq:
        picture = Assets.icons.arrowLeft3;
        break;
      case Comparison.l:
        picture = Assets.icons.arrowLeft2;
        break;
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.neural200,
        onPrimary: ColorName.neural400,
        shadowColor: Colors.transparent,
        shape: const CircleBorder(),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: picture.svg(
          fit: BoxFit.scaleDown,
          color: ColorName.neural700,
        ),
      ),
    );
  }
}
