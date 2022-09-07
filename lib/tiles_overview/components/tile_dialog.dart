import 'package:bee/edit_tile/edit_tile.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/tiles_overview/bloc/bloc.dart';
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
    required this.isAdmin,
  });

  final FieldId? dashboardID;
  final BuildContext pContext;
  final List<Attribute> attributes;
  final Tile tile;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TilesOverviewBloc, TilesOverviewState>(
      builder: (context, state) {
        // get theme
        final textTheme = Theme.of(context).textTheme;
        // get device in project
        final devicesInSelectedProject = state.devicesInSelectedProject;

        return SimpleDialog(
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              onPressed: () => Navigator.of(context).pop(
                () => Navigator.of(pContext).push(
                  EditTilePage.route(
                    dashboardID: dashboardID!,
                    type: tile.type,
                    devices: devicesInSelectedProject,
                    attributes: attributes,
                    initialTile: tile,
                    isEdit: false,
                    isAdmin: isAdmin,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Detail',
                    style: textTheme.bodyMedium!
                        .copyWith(color: ColorName.neural700),
                  ),
                ],
              ),
            ),
            if (isAdmin)
              SimpleDialogOption(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                onPressed: () => Navigator.of(context).pop(
                  () => pContext
                      .read<TilesOverviewBloc>()
                      .add(TileDeletedRequested(tile.id)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Delete',
                      style: textTheme.bodyMedium!
                          .copyWith(color: ColorName.neural700),
                    ),
                  ],
                ),
              )
          ],
        );
      },
    );
  }
}
