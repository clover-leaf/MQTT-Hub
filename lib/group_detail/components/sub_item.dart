import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class SubItem extends StatelessWidget {
  const SubItem({
    super.key,
    required this.title,
    required this.visible,
    required this.onPressed,
  });

  final String title;
  final bool visible;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: visible ? 56 : 0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 0,
          primary: ColorName.pine200,
          onPrimary: ColorName.pine300,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 28, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: textTheme.bodyMedium!.copyWith(
                  color: ColorName.neural700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
