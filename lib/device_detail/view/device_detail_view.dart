import 'package:bee/components/component.dart';
import 'package:bee/device_detail/device_detail.dart';
import 'package:bee/edit_device/edit_device.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DeviceDetailView extends StatelessWidget {
  const DeviceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final trackingDevices =
        context.select((DeviceDetailBloc bloc) => bloc.state.trackingDevices);
    final trackingAttributes = context
        .select((DeviceDetailBloc bloc) => bloc.state.trackingAttributes);
    final showedAttributes =
        context.select((DeviceDetailBloc bloc) => bloc.state.showedAttributes);
    final isAdmin =
        context.select((DeviceDetailBloc bloc) => bloc.state.isAdmin);
    final paddingTop = MediaQuery.of(context).viewPadding.top;

    return BlocListener<DeviceDetailBloc, DeviceDetailState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isProcessing()) {
          context.loaderOverlay.show();
        } else {
          if (state.status.isSuccess()) {
            if (state.isDeleted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  TSnackbar.success(
                    context,
                    content: 'Device has deleted successfully',
                  ),
                );
            }
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Title(),
                  const SizedBox(height: 20),
                  if (showedAttributes.isNotEmpty)
                    Expanded(
                      child: TrackingTab(
                        attributes: showedAttributes,
                        trackingDevices: trackingDevices,
                        trackingAttributes: trackingAttributes,
                      ),
                    ),
                ],
              ),
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
    final device = context.select((DeviceDetailBloc bloc) => bloc.state.device);
    final attributes =
        context.select((DeviceDetailBloc bloc) => bloc.state.attributes);
    final brokerInProjects =
        context.select((DeviceDetailBloc bloc) => bloc.state.brokerInProjects);
    final deviceTypeInProjects = context
        .select((DeviceDetailBloc bloc) => bloc.state.deviceTypeInProjects);

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
            onPressed: () =>
                context.read<DeviceDetailBloc>().add(const DeletionRequested()),
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
            label: 'DETAIL',
            onPressed: () {
              final _attributes =
                  attributes.where((att) => att.deviceID == device.id).toList();
              Navigator.of(context).push(
                EditDevicePage.route(
                  parentGroupID: device.groupID,
                  brokers: brokerInProjects,
                  deviceTypes: deviceTypeInProjects,
                  allAttributes: attributes,
                  initialAttributes: _attributes,
                  initialDevice: device,
                  isUseDeviceType: device.deviceTypeID != null,
                  isAdmin: isAdmin,
                  isEdit: false,
                ),
              );
            },
            enabled: true,
            textStyle: textTheme.labelLarge!.copyWith(
              color: ColorName.sky500,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.1,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        const SizedBox(width: 12),
        // TCircleButton(
        //   picture: Assets.icons.box.svg(),
        //   onPressed: () => Navigator.of(context).push(
        //     RecordsOverviewPage.route(
        //       device: device,
        //       attributes: showedAttributes,
        //     ),
        //   ),
        //   // context.read<DeviceDetailBloc>().add(const DonwloadRequested()),
        // )
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final device = context.select((DeviceDetailBloc bloc) => bloc.state.device);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          device.name,
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.05,
            color: ColorName.neural700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          device.description ?? 'Records',
          style: textTheme.labelMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorName.neural600,
          ),
        ),
      ],
    );
  }
}
