import 'dart:convert';

import 'package:bee/edit_tile/data/data.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/tiles_overview/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MultiCommandWidget extends StatelessWidget {
  const MultiCommandWidget({
    super.key,
    required this.tile,
    required this.value,
  });

  final Tile tile;
  final String value;

  @override
  Widget build(BuildContext context) {
    // decode lob
    // we will get {'commands': [{''icon':'abc','value':'12','label':'abc'}]}
    final decoded = jsonDecode(tile.lob) as Map<String, dynamic>;
    final commandsInJson = decoded['commands']! as List<dynamic>;
    final commands = commandsInJson
        .map((json) => Command.fromJson(json as Map<String, dynamic>))
        .toList();

    // param
    const padding = 4.0;

    return Column(
      children: [
        Wrap(
          spacing: padding,
          runSpacing: padding,
          children: commands
              .map(
                (cm) => _CommandItem(
                  command: cm,
                  isSelected: cm.value == value,
                  onPressed: () => context.read<TilesOverviewBloc>().add(
                        GatewayPublishRequested(
                          deviceID: tile.deviceID,
                          attributeID: tile.attributeID,
                          value: cm.value,
                        ),
                      ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16)
      ],
    );
  }
}

class _CommandItem extends StatelessWidget {
  const _CommandItem({
    required this.command,
    required this.onPressed,
    required this.isSelected,
  });

  final Command command;
  final void Function() onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final icon = TileHelper.stringToSvg(command.icon);
    final label = command.label;
    const size = 64.0;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        primary: Colors.transparent,
        onPrimary: ColorName.sky300,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      onPressed: onPressed,
      child: SizedBox(
        height: size,
        width: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon.svg(
              fit: BoxFit.scaleDown,
              color: isSelected ? ColorName.neural700 : ColorName.neural500,
            ),
            Text(
              label,
              style: textTheme.titleSmall!.copyWith(
                color: isSelected ? ColorName.neural700 : ColorName.neural500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
