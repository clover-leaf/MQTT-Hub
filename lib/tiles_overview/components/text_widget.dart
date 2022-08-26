import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.value,
    required this.unit,
  });

  final String? value;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value!,
            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
          if (unit != null)
            Text(
              unit!,
              style: textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: ColorName.sky300,
              ),
            ),
        ],
      ),
    );
  }
}
