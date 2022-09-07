import 'package:bee/components/component.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class DeviceTypeItem extends StatelessWidget {
  const DeviceTypeItem({
    super.key,
    required this.deviceType,
    required this.isAdmin,
    required this.onPressed,
    required this.onDeletePressed,
  });

  final DeviceType deviceType;
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
                    deviceType.name,
                    style: textTheme.bodyLarge!.copyWith(
                      color: ColorName.neural700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
