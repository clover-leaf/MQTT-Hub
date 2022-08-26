import 'package:bee/components/t_circle_button.dart';
import 'package:bee/edit_tile/edit_tile.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/tiles_overview/bloc/bloc.dart';
import 'package:bee/tiles_overview/components/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class TileDialog extends StatelessWidget {
  const TileDialog({
    super.key,
    required this.pContext,
    required this.dashboardID,
    required this.attributes,
    required this.tile,
  });

  final FieldId? dashboardID;
  final BuildContext pContext;
  final List<Attribute> attributes;
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TilesOverviewBloc, TilesOverviewState>(
      builder: (context, state) {
        // get theme
        final textTheme = Theme.of(context).textTheme;
        // get tiles value view
        final tileValueView = state.tileValueView;
        final value = tileValueView[tile.id];
        //
        final attributeView = state.attributeView;
        final attribute = attributeView[tile.attributeID];
        // get color
        final color = TileHelper.stringToColor(tile.color);
        // get icon
        final icon = TileHelper.stringToSvg(tile.icon);
        // get device in project
        final devicesInSelectedProject = state.devicesInSelectedProject;

        return Dialog(
          alignment: Alignment.topCenter,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 180),
          elevation: 0,
          backgroundColor: ColorName.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                      child: icon.svg(
                        color: ColorName.white,
                        fit: BoxFit.scaleDown,
                        height: 18,
                        width: 18,
                      ),
                    )
                  ],
                ),
                if (value == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 24),
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                              color: ColorName.iColor1,),
                        ),
                      ),
                    ],
                  )
                else if (tile.type.isText)
                  TextWidget(value: value, unit: attribute?.unit)
                else if (tile.type.isRadialGauge)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: RadialGaugeWidget(
                      lob: tile.lob,
                      value: value,
                      unit: attribute?.unit,
                    ),
                  )
                else if (tile.type.isLinearGauge)
                  LinearGaugeWidget(
                    lob: tile.lob,
                    value: value,
                    unit: attribute?.unit,
                  )
                else if (tile.type.isToggle)
                  ToggleWidget(tile: tile, value: value),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TCircleButton(
                      picture: Assets.icons.box.svg(
                        fit: BoxFit.scaleDown,
                        color: ColorName.neural700,
                      ),
                      onPressed: () {
                        // this case almost never happen!
                        if (dashboardID == null) {
                          Navigator.of(context).pop(() {});
                        } else {
                          Navigator.of(context).pop(
                            () => Navigator.of(pContext).push(
                              EditTilePage.route(
                                dashboardID: dashboardID!,
                                type: tile.type,
                                devices: devicesInSelectedProject,
                                attributes: attributes,
                                initialTile: tile,
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
