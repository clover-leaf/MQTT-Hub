import 'package:bee/components/component.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class BrokerItem extends StatelessWidget {
  const BrokerItem({
    super.key,
    required this.broker,
    required this.isAdmin,
    required this.onPressed,
    required this.onDeletePressed,
  });

  final Broker broker;
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
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  broker.name,
                  style: textTheme.bodyLarge!.copyWith(
                    color: ColorName.neural700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _StatItem(
                      url: broker.url,
                      port: broker.port.toString(),
                      image: Assets.icons.global,
                    ),
                  ],
                )
              ],
            ),
            if (isAdmin) const Spacer(),
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
  const _StatItem({
    required this.url,
    required this.port,
    required this.image,
  });

  final String url;
  final String port;
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
          '$url:$port',
          style: textTheme.labelMedium!.copyWith(color: ColorName.sky600),
        ),
      ],
    );
  }
}
