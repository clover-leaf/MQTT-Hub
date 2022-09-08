import 'dart:convert';

import 'package:bee/edit_tile/data/data.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/tiles_overview/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class ToggleWidget extends StatelessWidget {
  const ToggleWidget({
    super.key,
    required this.tile,
    required this.value,
  });

  final Tile tile;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // decode lob
    // we will get {'left':[{'value':'12','label':'on','color':'#123456'}]}
    final decoded = jsonDecode(tile.lob) as Map<String, dynamic>;
    // get ranges
    final left = decoded['left']! as Map<String, dynamic>;
    final right = decoded['right']! as Map<String, dynamic>;
    // convert them to left, right config
    final leftConfig = ToggleConfig.fromJson(left);
    final rightConfig = ToggleConfig.fromJson(right);
    final leftColor = TileHelper.stringToColor(leftConfig.color);
    final rightColor = TileHelper.stringToColor(rightConfig.color);
    final isActiveLeft = value == leftConfig.value;
    final isActiveRight = value == rightConfig.value;

    // param
    const paddingCoefficient = 0.2;
    const spacingCoefficient = 0.075;
    const aspectRatio = 1.75;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (isActiveLeft) {
          context.read<TilesOverviewBloc>().add(
                GatewayPublishRequested(
                  deviceID: tile.deviceID,
                  attributeID: tile.attributeID,
                  value: rightConfig.value,
                ),
              );
        } else if (isActiveRight) {
          context.read<TilesOverviewBloc>().add(
                GatewayPublishRequested(
                  deviceID: tile.deviceID,
                  attributeID: tile.attributeID,
                  value: leftConfig.value,
                ),
              );
        } else {
          context.read<TilesOverviewBloc>().add(
                GatewayPublishRequested(
                  deviceID: tile.deviceID,
                  attributeID: tile.attributeID,
                  value: leftConfig.value,
                ),
              );
        }
      },
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: aspectRatio,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.maxHeight;
                final radius = height * (1 - 2 * paddingCoefficient) / 2;
                final padding = height * paddingCoefficient;
                late Color color;
                if (isActiveLeft) {
                  color = leftColor;
                } else if (isActiveRight) {
                  color = rightColor;
                } else {
                  color = ColorName.neural500;
                }
                return Padding(
                  padding: EdgeInsets.all(padding),
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.all(Radius.circular(radius)),
                    ),
                    duration: const Duration(milliseconds: 400),
                  ),
                );
              },
            ),
          ),
          AspectRatio(
            aspectRatio: aspectRatio,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.maxHeight;
                final width = constraints.maxWidth;
                final radius = height *
                    (1 - 2 * spacingCoefficient - 2 * paddingCoefficient);
                final spacing = height * spacingCoefficient;
                final padding = height * paddingCoefficient;
                late double paddingLeft;
                String? label;
                if (isActiveLeft) {
                  paddingLeft = width - 2 * padding - spacing - radius;
                  label = leftConfig.label;
                } else if (isActiveRight) {
                  paddingLeft = spacing * 1.2;
                  label = rightConfig.label;
                } else {
                  paddingLeft = width - 2 * padding - spacing - radius;
                  label = leftConfig.label;
                }
                return Padding(
                  padding: EdgeInsets.all(padding),
                  child: AnimatedContainer(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(paddingLeft, spacing, 0, 0),
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      alignment: Alignment.center,
                      height: radius,
                      width: radius,
                      child: label != null
                          ? Text(
                              label.toUpperCase(),
                              style: textTheme.bodyMedium!.copyWith(
                                color: ColorName.white,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                );
              },
            ),
          ),
          AspectRatio(
            aspectRatio: aspectRatio,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.maxHeight;
                final width = constraints.maxWidth;
                final radius = height *
                    (1 - 2 * spacingCoefficient - 2 * paddingCoefficient);
                final spacing = height * spacingCoefficient;
                final padding = height * paddingCoefficient;
                late double paddingLeft;
                if (isActiveLeft) {
                  paddingLeft = spacing;
                } else if (isActiveRight) {
                  paddingLeft = width - 2 * padding - spacing - radius;
                } else {
                  paddingLeft = spacing;
                }
                return Padding(
                  padding: EdgeInsets.all(padding),
                  child: AnimatedContainer(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(paddingLeft, spacing, 0, 0),
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      height: radius,
                      width: radius,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorName.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
