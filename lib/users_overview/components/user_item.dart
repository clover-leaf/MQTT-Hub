import 'package:bee/components/component.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.user,
    required this.isAdmin,
    required this.onPressed,
    required this.onDeletePressed,
  });

  final User user;
  final bool isAdmin;
  final void Function() onPressed;
  final void Function() onDeletePressed;

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
      onPressed: () {
        if (isAdmin) {
          onPressed.call();
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: textTheme.bodyLarge!.copyWith(
                      color: ColorName.neural700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StatItem(password: user.password),
                      const SizedBox(width: 14),
                    ],
                  )
                ],
              ),
            ),
            if (isAdmin)
              TCircleButton(
                picture: Assets.icons.trash.svg(
                  fit: BoxFit.scaleDown,
                  color: ColorName.neural600,
                ),
                onPressed: onDeletePressed,
              )
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Assets.icons.key.svg(
          fit: BoxFit.scaleDown,
          color: ColorName.neural600,
          height: 18,
          width: 18,
        ),
        const SizedBox(width: 4),
        Text(
          password,
          style: textTheme.labelMedium!.copyWith(color: ColorName.sky600),
        ),
      ],
    );
  }
}
