import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/group_detail/view/group_detail_page.dart';
import 'package:bee/groups_overview/bloc/groups_overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class GroupsOverviewView extends StatelessWidget {
  const GroupsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final rootGroup =
        context.select((GroupsOverviewBloc bloc) => bloc.state.rootGroup);

    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 32,
      ),
      children: [const _Header(), ...rootGroup.map(_GroupItem.new)],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final project =
        context.select((GroupsOverviewBloc bloc) => bloc.state.project);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.name,
            style: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Groups',
            style: textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupItem extends StatelessWidget {
  const _GroupItem(this.group);

  final Group group;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final project =
        context.select((GroupsOverviewBloc bloc) => bloc.state.project);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.white,
        onPrimary: ColorName.blue,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: () => Navigator.of(context).push(
        GroupDetailPage.route(
          group: group,
          parentProject: project,
          parentGroup: null,
        ),
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              group.name,
              style: textTheme.titleMedium,
            ),
            Assets.icons.more.svg()
          ],
        ),
      ),
    );
  }
}
