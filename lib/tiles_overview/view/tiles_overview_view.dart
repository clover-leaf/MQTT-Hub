import 'package:bee/app/app.dart';
import 'package:bee/components/component.dart';
import 'package:bee/tiles_overview/bloc/bloc.dart';
import 'package:bee/tiles_overview/components/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:user_repository/user_repository.dart';

class TilesOverviewView extends StatelessWidget {
  const TilesOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TilesOverviewBloc>().state;

    // get selected project
    final selectedProjectID = state.selectedProjectID;
    final projectView = state.projectView;
    final selectedProject = projectView[selectedProjectID];

    // get selected dashboards
    final projectDashboardView = state.projectDashboardView;
    final selectedDashboardID = projectDashboardView[selectedProjectID];

    // get dashboard of project
    final showedDashboards = state.showedDashboards;

    // get showed tiles
    final showedTiles = state.tiles
        .where((tl) => tl.dashboardID == selectedDashboardID)
        .toList();

    // get list props to navigate EditTile page
    // final devicesInSelectedProject = state.devicesInSelectedProject;
    final attributeView = state.attributeView;

    // get tiles value view
    final tileValueView = state.tileValueView;

    // get device view
    final deviceView = state.deviceView;

    // get broker status view
    final brokerStatusView = state.brokerStatusView;

    // get is admin
    final isAdmin = state.isAdmin;

    // tile width
    final mediaWidth = MediaQuery.of(context).size.width;
    final tileWidth = (mediaWidth - 48) / 2;

    final paddingTop = MediaQuery.of(context).viewPadding.top;

    return BlocListener<TilesOverviewBloc, TilesOverviewState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isProcessing()) {
          if (!context.loaderOverlay.visible) {
            context.loaderOverlay.show();
          }
        } else {
          if (context.loaderOverlay.visible) {
            context.loaderOverlay.hide();
          }
          if (state.status.isSuccess()) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                TSnackbar.success(
                  context,
                  content: 'Broker has deleted successfully',
                ),
              );
            if (context.loaderOverlay.visible) {
              context.loaderOverlay.hide();
            }
          } else if (state.status.isFailure()) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                TSnackbar.error(context, content: state.error!),
              );
            if (context.loaderOverlay.visible) {
              context.loaderOverlay.hide();
            }
          }
          if (state.isLogout) {
            if (!context.loaderOverlay.visible) {
              context.loaderOverlay.show();
            }
            context.read<AppBloc>().add(const AppUnauthenticated());
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 1.5 * paddingTop),
            _Header(selectedProject: selectedProject),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: showedDashboards.length,
                itemBuilder: (context, index) {
                  final db = showedDashboards[index];
                  return DashboardItem(
                    title: db.name,
                    isSelected: db.id == selectedDashboardID,
                    onPressed: () => context
                        .read<TilesOverviewBloc>()
                        .add(SelectedDashboardChanged(db.id)),
                  );
                },
              ),
            ),
            Expanded(
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                itemCount: showedTiles.length,
                itemBuilder: (context, index) {
                  final tile = showedTiles[index];
                  final device = deviceView[tile.deviceID];
                  return TileWidget(
                    tile: tile,
                    width: tileWidth,
                    value: tileValueView[tile.id],
                    status: brokerStatusView[device?.brokerID],
                    unit: attributeView[tile.attributeID]?.unit,
                    isAdmin: isAdmin,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.selectedProject});

  final Project? selectedProject;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedProject?.name ?? 'No Project',
              style: textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
