import 'package:bee/components/t_snackbar.dart';
import 'package:bee/edit_tile/view/view.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/projects_overview/view/projects_overview_page.dart';
import 'package:bee/tiles_overview/tiles_overview.dart';
import 'package:bee/users_overview/users_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class TilesOverviewPage extends StatelessWidget {
  const TilesOverviewPage({super.key});

  static Page<void> page({required bool isAdmin}) => MaterialPage<void>(
        child: BlocProvider(
          create: (context) => TilesOverviewBloc(
            context.read<UserRepository>(),
            isAdmin: isAdmin,
          )..add(const InitializationRequested()),
          child: const TilesOverviewPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final projects =
        context.select((TilesOverviewBloc bloc) => bloc.state.projects);
    final selectedProjectID = context
        .select((TilesOverviewBloc bloc) => bloc.state.selectedProjectID);
    final projectDashboardView = context
        .select((TilesOverviewBloc bloc) => bloc.state.projectDashboardView);
    final devicesInSelectedProject = context.select(
      (TilesOverviewBloc bloc) => bloc.state.devicesInSelectedProject,
    );
    final attributes =
        context.select((TilesOverviewBloc bloc) => bloc.state.attributes);
    final dashboardID = projectDashboardView[selectedProjectID];

    final isAdmin =
        context.select((TilesOverviewBloc bloc) => bloc.state.isAdmin);

    return Scaffold(
      backgroundColor: ColorName.darkWhite,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: ColorName.sky400,
              splashColor: ColorName.sky500,
              foregroundColor: ColorName.sky500,
              onPressed: () async => showMaterialModalBottomSheet<TileType?>(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (bContext) => const TileSheet(),
              ).then((value) {
                if (value != null) {
                  if (dashboardID == null) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        TSnackbar.error(
                          context,
                          content: 'There must be atleast one dashboard'
                              ' to add new tile',
                        ),
                      );
                  } else {
                    Navigator.of(context).push(
                      EditTilePage.route(
                        dashboardID: dashboardID,
                        type: value,
                        devices: devicesInSelectedProject,
                        attributes: attributes,
                        initialTile: null,
                      ),
                    );
                  }
                }
              }),
              child: Assets.icons.add.svg(color: ColorName.white),
            )
          : const SizedBox.shrink(),
      bottomNavigationBar: BottomAppBar(
        color: ColorName.white,
        elevation: 24,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async =>
                    showMaterialModalBottomSheet<Map<String, dynamic>>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (bContext) =>
                      MenuSheet(projects: projects, isAdmin: isAdmin),
                ).then((callback) {
                  if (callback != null) {
                    final category = callback['category'] as int;
                    // change project ID
                    if (category == 1) {
                      final projectID = callback['project_id'] as String;
                      context
                          .read<TilesOverviewBloc>()
                          .add(SelectedProjectChanged(projectID));
                    }
                    // navigator to screen
                    else if (category == 2) {
                      final option = callback['option'] as int;
                      // project page
                      if (option == 1) {
                        Navigator.of(context).push<void>(
                          ProjectsOverviewPage.route(isAdmin: isAdmin),
                        );
                      }
                      // user page
                      else if (option == 2) {
                        Navigator.of(context).push<void>(
                          UsersOverviewPage.route(
                            isAdmin: isAdmin,
                            parentProject: null,
                          ),
                        );
                      }
                      // log out
                      else if (option == 3) {
                        context
                            .read<TilesOverviewBloc>()
                            .add(const LogoutRequested());
                      }
                    }
                  }
                }),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: const CircleBorder(),
                  primary: ColorName.white,
                  onPrimary: ColorName.sky300,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(16),
                ),
                child: Assets.icons.textalignLeft.svg(),
              ),
              ElevatedButton(
                onPressed: () async {
                  await showMaterialModalBottomSheet<void>(
                    context: context,
                    builder: (context) => Container(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: const CircleBorder(),
                  primary: ColorName.white,
                  onPrimary: ColorName.sky300,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(16),
                ),
                child: Assets.icons.lock.svg(),
              ),
            ],
          ),
        ),
      ),
      body: const TilesOverviewView(),
    );
  }
}
