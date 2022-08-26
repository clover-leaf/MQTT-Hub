import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class TileSheet extends StatelessWidget {
  const TileSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // define tile item size
    const size = 96.0;
    // filter tile which is monitor
    final monitorTileType =
        TileType.values.where((type) => type.isMonitorTile).toList();
    // filter tile which is command
    final commandTileType =
        TileType.values.where((type) => type.isCommandTile).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: const BoxDecoration(
        color: ColorName.darkWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MONITOR',
            style: textTheme.bodySmall!.copyWith(color: ColorName.neural600),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: size,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final type = monitorTileType[index];
                return _TileItem(
                  type: type,
                  onPressed: () => Navigator.of(context).pop(type),
                );
              },
              itemCount: monitorTileType.length,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'CONTROLLER',
            style: textTheme.bodySmall!.copyWith(color: ColorName.neural600),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: size,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final type = commandTileType[index];
                return _TileItem(
                  type: type,
                  onPressed: () => Navigator.of(context).pop(type),
                );
              },
              itemCount: commandTileType.length,
            ),
          )
        ],
      ),
    );
  }
}

class _TileItem extends StatelessWidget {
  const _TileItem({
    required this.type,
    required this.onPressed,
  });

  final TileType type;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    late SvgGenImage picture;
    if (type.isText) {
      picture = Assets.icons.text;
    } else if (type.isRadialGauge) {
      picture = Assets.icons.speedometer;
    } else if (type.isLinearGauge) {
      picture = Assets.icons.passwordCheck;
    } else if (type.isToggle) {
      picture = Assets.icons.toggleOnCircle;
    } else if (type.isMultiCommand) {
      picture = Assets.icons.category2;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        primary: ColorName.white,
        onPrimary: ColorName.sky300,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      onPressed: onPressed,
      child: AspectRatio(
        aspectRatio: 1,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: picture.svg(
                color: ColorName.neural600,
                fit: BoxFit.scaleDown,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  type.getTitle(),
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: ColorName.neural700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
