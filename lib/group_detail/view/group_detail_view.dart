import 'package:bee/device_detail/view/view.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/group_detail/group_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class GroupDetailView extends StatelessWidget {
  const GroupDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final childGroup =
        context.select((GroupDetailBloc bloc) => bloc.state.childGroup);
    final childDevice =
        context.select((GroupDetailBloc bloc) => bloc.state.childDevice);

    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 32,
      ),
      children: [
        const _Header(),
        const _SessionTitle('groups'),
        if (childGroup.isNotEmpty)
          ...childGroup.map(
            (gr) => _GroupItem(
              group: gr,
            ),
          )
        else
          const SizedBox(height: 64),
        const _SessionTitle('devices'),
        if (childDevice.isNotEmpty)
          ...childDevice.map(
            (dv) => _DeviceItem(
              device: dv,
            ),
          )
        else
          const SizedBox(height: 64),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final group = context.select((GroupDetailBloc bloc) => bloc.state.group);
    final path = context.select((GroupDetailBloc bloc) => bloc.state.path);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.name,
            style: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            path,
            style: textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionTitle extends StatelessWidget {
  const _SessionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: textTheme.labelMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupItem extends StatelessWidget {
  const _GroupItem({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final curGroup = context.select((GroupDetailBloc bloc) => bloc.state.group);
    final path = context.select((GroupDetailBloc bloc) => bloc.state.path);
    final rootProject =
        context.select((GroupDetailBloc bloc) => bloc.state.rootProject);

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
          path: '$path / ${curGroup.name}',
          rootProject: rootProject,
          group: group,
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

class _DeviceItem extends StatelessWidget {
  const _DeviceItem({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final curGroup = context.select((GroupDetailBloc bloc) => bloc.state.group);
    final path = context.select((GroupDetailBloc bloc) => bloc.state.path);

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
        DeviceDetailPage.route(
          path: '$path / ${curGroup.name}',
          device: device,
        ),
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              device.name,
              style: textTheme.titleMedium,
            ),
            Assets.icons.more.svg()
          ],
        ),
      ),
    );
  }
}
