import 'package:bee/components/component.dart';
import 'package:bee/edit_project/view/edit_project_page.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/project_detail/view/project_detail_page.dart';
import 'package:bee/projects_overview/bloc/projects_overview_bloc.dart';
import 'package:bee/projects_overview/components/project_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectsOverviewView extends StatelessWidget {
  const ProjectsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final projects =
        context.select((ProjectsOverviewBloc bloc) => bloc.state.projects);
    final dashboards =
        context.select((ProjectsOverviewBloc bloc) => bloc.state.dashboards);
    final brokers =
        context.select((ProjectsOverviewBloc bloc) => bloc.state.brokers);
    final userProjects =
        context.select((ProjectsOverviewBloc bloc) => bloc.state.userProjects);
    final isAdmin =
        context.select((ProjectsOverviewBloc bloc) => bloc.state.isAdmin);
    final paddingTop = MediaQuery.of(context).viewPadding.top;

    return Column(
      children: [
        SizedBox(height: paddingTop),
        _Header(isAdmin: isAdmin),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const _Title(),
              const SizedBox(height: 20),
              ...projects.map((pr) {
                final _dashboard =
                    dashboards.where((db) => db.projectID == pr.id).toList();
                final _broker =
                    brokers.where((br) => br.projectID == pr.id).toList();
                final _userProjects = userProjects
                    .where((usPr) => usPr.projectID == pr.id)
                    .toList();
                return Column(
                  children: [
                    ProjectItem(
                      project: pr,
                      dashboardNumber: _dashboard.length,
                      brokerNumber: _broker.length,
                      userNumber: _userProjects.length,
                      onPressed: () => Navigator.of(context).push(
                        ProjectDetailPage.route(
                            projectID: pr.id, isAdmin: isAdmin,),
                      ),
                    ),
                    const SizedBox(height: 16)
                  ],
                );
              }).toList()
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isAdmin});

  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TCircleButton(
          picture: Assets.icons.arrowLeft
              .svg(color: ColorName.neural700, fit: BoxFit.scaleDown),
          onPressed: () => Navigator.of(context).pop(),
        ),
        if (isAdmin)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TSecondaryButton(
              label: 'ADD PROJECT',
              onPressed: () => Navigator.of(context)
                  .push(EditProjectPage.route(initialProject: null)),
              enabled: true,
              textStyle: textTheme.labelLarge!.copyWith(
                color: ColorName.sky500,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.1,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          )
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project'.toUpperCase(),
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
