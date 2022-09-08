import 'package:bee/edit_tile/data/data.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/tiles_overview/bloc/bloc.dart';
import 'package:bee/tiles_overview/components/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateway_client/gateway_client.dart';
import 'package:user_repository/user_repository.dart';

class TileWidget extends StatelessWidget {
  const TileWidget({
    super.key,
    required this.tile,
    required this.width,
    required this.value,
    required this.status,
    required this.unit,
    required this.isAdmin,
  });

  final Tile tile;
  final double width;
  final String? value;
  final String? unit;
  final ConnectionStatus? status;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // get color
    final color = TileHelper.stringToColor(tile.color);
    // get icon
    final icon = TileHelper.stringToSvg(tile.icon);

    final attributes =
        context.select((TilesOverviewBloc bloc) => bloc.state.attributes);

    // get selected dashboards
    final projectDashboardView = context
        .select((TilesOverviewBloc bloc) => bloc.state.projectDashboardView);
    final selectedProjectID = context
        .select((TilesOverviewBloc bloc) => bloc.state.selectedProjectID);
    final selectedDashboardID = projectDashboardView[selectedProjectID];

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.white,
        onPrimary: color.withAlpha(106),
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      onPressed: () => showDialog<void Function()?>(
        context: context,
        builder: (bContext) => BlocProvider.value(
          value: BlocProvider.of<TilesOverviewBloc>(context),
          child: TileDialog(
            pContext: context,
            dashboardID: selectedDashboardID,
            attributes: attributes,
            tile: tile,
            isAdmin: isAdmin,
          ),
        ),
      ).then((callback) => callback?.call()),
      child: Container(
        width: width,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    tile.name,
                    style: textTheme.titleSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color,
                  child: icon.svg(
                    color: ColorName.white,
                    fit: BoxFit.scaleDown,
                    height: 18,
                    width: 18,
                  ),
                ),
              ],
            ),
            if (status != null && status!.isConnecting && value == null)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
                child: Text(
                  'Connecting to broker',
                  style:
                      textTheme.labelMedium!.copyWith(color: ColorName.sky500),
                ),
              )
            else if (status != null && status!.isConnecting)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
                child: Text(
                  'Reconnecting to broker',
                  style:
                      textTheme.labelMedium!.copyWith(color: ColorName.sky500),
                ),
              )
            else if (status != null &&
                status!.isConnected &&
                tile.type.isToggle)
              ToggleWidget(tile: tile, value: value)
            else if (status != null &&
                status!.isConnected &&
                tile.type.isMultiCommand)
              MultiCommandWidget(tile: tile, value: value)
            else if (status != null && status!.isConnected && value == null)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
                child: Text(
                  'Waiting for message',
                  style:
                      textTheme.labelMedium!.copyWith(color: ColorName.sky500),
                ),
              ),
            const SizedBox(height: 8),
            if (value == null)
              const SizedBox.shrink()
            else if (tile.type.isText)
              TextWidget(value: value!, unit: unit)
            else if (tile.type.isRadialGauge)
              RadialGaugeWidget(
                lob: tile.lob,
                value: value!,
                unit: unit,
              )
            else if (tile.type.isLinearGauge)
              LinearGaugeWidget(lob: tile.lob, value: value!, unit: unit)
            else if (tile.type.isLine)
              LineWidget(lob: tile.lob, value: value!, unit: unit)
            else if (tile.type.isBar)
              BarWidget(lob: tile.lob, value: value!, unit: unit)
          ],
        ),
      ),
    );
  }
}
