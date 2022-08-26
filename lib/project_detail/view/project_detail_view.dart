import 'package:bee/brokers_overview/view/brokers_overview_page.dart';
import 'package:bee/components/component.dart';
import 'package:bee/dashboards_overview/view/view.dart';
import 'package:bee/edit_project/view/edit_project_page.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/groups_overview/view/groups_overview_page.dart';
import 'package:bee/project_detail/bloc/project_detail_bloc.dart';
import 'package:bee/project_detail/components/option_item.dart';
import 'package:bee/users_overview/view/users_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ProjectDetailView extends StatelessWidget {
  const ProjectDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    final project =
        context.select((ProjectDetailBloc bloc) => bloc.state.project);
    final groupNumber =
        context.select((ProjectDetailBloc bloc) => bloc.state.groupNumber);
    final dashboardNumber =
        context.select((ProjectDetailBloc bloc) => bloc.state.dashboardNumber);
    final brokerNumber =
        context.select((ProjectDetailBloc bloc) => bloc.state.brokerNumber);
    final userNumber =
        context.select((ProjectDetailBloc bloc) => bloc.state.userNumber);
    final isAdmin =
        context.select((ProjectDetailBloc bloc) => bloc.state.isAdmin);

    return BlocListener<ProjectDetailBloc, ProjectDetailState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isProcessing()) {
          context.loaderOverlay.show();
        } else {
          if (state.status.isSuccess()) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                TSnackbar.success(
                  context,
                  content: 'Project has deleted successfully',
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
        }
      },
      child: Column(
        children: [
          SizedBox(height: paddingTop),
          _Header(isAdmin: isAdmin),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const _Title(),
                const SizedBox(height: 20),
                OptionItem(
                  title: 'Groups',
                  number: groupNumber,
                  unit: 'group',
                  onPressed: () => Navigator.of(context).push(
                    GroupsOverviewPage.route(
                      parentProject: project,
                      isAdmin: isAdmin,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OptionItem(
                  title: 'Dashboards',
                  number: dashboardNumber,
                  unit: 'dashboard',
                  onPressed: () => Navigator.of(context).push(
                    DashboardsOverviewPage.route(
                      isAdmin: isAdmin,
                      parentProject: project,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OptionItem(
                  title: 'Brokers',
                  number: brokerNumber,
                  unit: 'broker',
                  onPressed: () => Navigator.of(context).push(
                    BrokersOverviewPage.route(
                      isAdmin: isAdmin,
                      parentProject: project,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OptionItem(
                  title: 'Users',
                  number: userNumber,
                  unit: 'user',
                  onPressed: () => Navigator.of(context).push(
                    UsersOverviewPage.route(
                      isAdmin: isAdmin,
                      parentProject: project,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isAdmin});

  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final project =
        context.select((ProjectDetailBloc bloc) => bloc.state.project);

    return Row(
      children: [
        TCircleButton(
          picture: Assets.icons.arrowLeft
              .svg(color: ColorName.neural700, fit: BoxFit.scaleDown),
          onPressed: () => Navigator.of(context).pop(),
        ),
        if (isAdmin) const Spacer(),
        if (isAdmin)
          TSecondaryButton(
            label: 'DELETE',
            onPressed: () => context
                .read<ProjectDetailBloc>()
                .add(const DeletionRequested()),
            enabled: true,
            textStyle: textTheme.labelLarge!.copyWith(
              color: ColorName.sky500,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.1,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        if (isAdmin) const SizedBox(width: 4),
        if (isAdmin)
          TSecondaryButton(
            label: 'EDIT',
            onPressed: () => Navigator.of(context)
                .push(EditProjectPage.route(initialProject: project)),
            enabled: true,
            textStyle: textTheme.labelLarge!.copyWith(
              color: ColorName.sky500,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.1,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        const SizedBox(width: 12),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final project =
        context.select((ProjectDetailBloc bloc) => bloc.state.project);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          project.name,
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.05,
            color: ColorName.neural700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Overview',
          style: textTheme.labelMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorName.neural600,
          ),
        ),
      ],
    );
  }
}
