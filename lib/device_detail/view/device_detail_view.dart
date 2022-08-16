import 'package:bee/device_detail/device_detail.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class DeviceDetailView extends StatelessWidget {
  const DeviceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final showedAttributes =
        context.select((DeviceDetailBloc bloc) => bloc.state.showedAttributes);

    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 32,
      ),
      children: [
        const _Header(),
        const _SessionTitle('Attributes'),
        ...showedAttributes.map(_AttributeItem.new).toList()
      ],
    );
  }
}

class _AttributeItem extends StatelessWidget {
  const _AttributeItem(this.attribute);

  final Attribute attribute;

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
      onPressed: () {},
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              attribute.name,
              style: textTheme.titleMedium,
            ),
            Text(
              attribute.jsonPath,
              style: textTheme.titleSmall,
            ),
          ],
        ),
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final device = context.select((DeviceDetailBloc bloc) => bloc.state.device);
    final path = context.select((DeviceDetailBloc bloc) => bloc.state.path);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            device.name,
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
