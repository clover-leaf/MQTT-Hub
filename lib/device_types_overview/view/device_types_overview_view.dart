import 'package:bee/components/component.dart';
import 'package:bee/device_types_overview/device_types_overview.dart';
import 'package:bee/edit_device_type/view/edit_device_type_page.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DeviceTypesOverviewView extends StatelessWidget {
  const DeviceTypesOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final showedDeviceTypes = context
        .select((DeviceTypesOverviewBloc bloc) => bloc.state.showedDeviceTypes);
    final parentProject = context
        .select((DeviceTypesOverviewBloc bloc) => bloc.state.parentProject);
    final isAdmin =
        context.select((DeviceTypesOverviewBloc bloc) => bloc.state.isAdmin);
    final attributes =
        context.select((DeviceTypesOverviewBloc bloc) => bloc.state.attributes);
    final paddingTop = MediaQuery.of(context).viewPadding.top;

    return BlocListener<DeviceTypesOverviewBloc, DeviceTypesOverviewState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isProcessing()) {
          context.loaderOverlay.show();
        } else {
          if (state.status.isSuccess()) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                TSnackbar.success(
                  context,
                  content: 'DeviceType has deleted successfully',
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
                ...showedDeviceTypes.map((dT) {
                  final attributeOfType = attributes
                      .where((att) => att.deviceTypeID == dT.id)
                      .toList();
                  return Column(
                    children: [
                      DeviceTypeItem(
                        isAdmin: isAdmin,
                        deviceType: dT,
                        onPressed: () => Navigator.of(context).push(
                          EditDeviceTypePage.route(
                            parentProjectID: parentProject.id,
                            initialAttributes: attributeOfType,
                            initialDeviceType: dT,
                            isAdmin: isAdmin,
                            isEdit: false,
                          ),
                        ),
                        onDeletePressed: () => context
                            .read<DeviceTypesOverviewBloc>()
                            .add(DeletionRequested(dT.id)),
                      ),
                      const SizedBox(height: 16)
                    ],
                  );
                }).toList()
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
    final parentProject = context
        .select((DeviceTypesOverviewBloc bloc) => bloc.state.parentProject);

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
              label: 'ADD DEVICE TYPE',
              onPressed: () => Navigator.of(context).push(
                EditDeviceTypePage.route(
                  parentProjectID: parentProject.id,
                  initialAttributes: [],
                  initialDeviceType: null,
                  isAdmin: isAdmin,
                  isEdit: true,
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
    final parentProject = context
        .select((DeviceTypesOverviewBloc bloc) => bloc.state.parentProject);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DEVICE TYPE',
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
