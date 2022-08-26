import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TProjectItem extends StatelessWidget {
  const TProjectItem({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: ColorName.white,
        onPrimary: ColorName.sky300,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: ColorName.darkBlue,
              child: Text(
                label[0].toUpperCase(),
                style: textTheme.titleMedium!.copyWith(
                  color: ColorName.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Text(label, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
