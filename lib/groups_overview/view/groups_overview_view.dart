import 'package:bee/components/component.dart';
import 'package:bee/edit_group/view/edit_group_page.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/group_detail/group_detail.dart';
import 'package:bee/groups_overview/bloc/groups_overview_bloc.dart';
import 'package:bee/groups_overview/components/group_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupsOverviewView extends StatelessWidget {
  const GroupsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final showedGroup =
        context.select((GroupsOverviewBloc bloc) => bloc.state.showedGroup);
    final parentProject =
        context.select((GroupsOverviewBloc bloc) => bloc.state.parentProject);
    final groups =
        context.select((GroupsOverviewBloc bloc) => bloc.state.groups);
    final devices =
        context.select((GroupsOverviewBloc bloc) => bloc.state.devices);
    final isAdmin =
        context.select((GroupsOverviewBloc bloc) => bloc.state.isAdmin);
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
              ...showedGroup.map((gr) {
                final childGroup =
                    groups.where((group) => group.groupID == gr.id).toList();
                final childDevice =
                    devices.where((dv) => dv.groupID == gr.id).toList();
                return Column(
                  children: [
                    GroupItem(
                      group: gr,
                      groupNumber: childGroup.length,
                      deviceNumber: childDevice.length,
                      onPressed: () => Navigator.of(context).push(
                        GroupDetailPage.route(
                          isAdmin: isAdmin,
                          rootProject: parentProject,
                          group: gr,
                        ),
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
    final parentProject =
        context.select((GroupsOverviewBloc bloc) => bloc.state.parentProject);

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
              label: 'ADD GROUP',
              onPressed: () => Navigator.of(context).push(
                EditGroupPage.route(
                  parentProjetID: parentProject.id,
                  parentGroupID: null,
                  initialGroup: null,
                ),
              ),
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
    final parentProject =
        context.select((GroupsOverviewBloc bloc) => bloc.state.parentProject);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GROUPS',
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.05,
            color: ColorName.neural700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          parentProject.name,
          style: textTheme.labelMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorName.neural600,
          ),
        ),
      ],
    );
  }
}
