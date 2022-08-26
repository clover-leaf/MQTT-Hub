import 'package:bee/components/t_secondary_button.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(32, 32, 32, 12),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      content: Text(
        'Are you sure to log out?',
        style: textTheme.bodyLarge!.copyWith(color: ColorName.neural700),
      ),
      actions: [
        TSecondaryButton(
          label: 'NO',
          onPressed: () => Navigator.of(context).pop(false),
          enabled: true,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        ),
        TSecondaryButton(
          label: 'YES',
          onPressed: () => Navigator.of(context).pop(true),
          enabled: true,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        )
      ],
    );
  }
}
