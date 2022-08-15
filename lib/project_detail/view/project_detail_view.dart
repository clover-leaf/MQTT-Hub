import 'package:bee/gen/colors.gen.dart';
import 'package:bee/groups_overview/view/view.dart';
import 'package:bee/project_detail/bloc/project_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectDetailView extends StatelessWidget {
  const ProjectDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final project =
        context.select((ProjectDetailBloc bloc) => bloc.state.project);

    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 32,
      ),
      children: [
        const _Header(),
        _Item(
          label: 'Groups',
          onPress: () =>
              Navigator.of(context).push(GroupsOverviewPage.route(project)),
        ),
        _Item(
          label: 'Dashboards',
          onPress: () {},
        ),
        _Item(
          label: 'Members',
          onPress: () {},
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final project =
        context.select((ProjectDetailBloc bloc) => bloc.state.project);

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
            'Overview',
            style: textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.label, required this.onPress});

  final String label;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.white,
        onPrimary: ColorName.blue,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: onPress,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Row(
          children: [
            Text(
              label,
              style: textTheme.titleMedium,
            )
          ],
        ),
      ),
    );
  }
}
