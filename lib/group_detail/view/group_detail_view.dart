import 'package:bee/components/component.dart';
import 'package:bee/device_detail/view/device_detail_page.dart';
import 'package:bee/edit_device/view/edit_device_page.dart';
import 'package:bee/edit_group/view/edit_group_page.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/group_detail/components/option_item.dart';
import 'package:bee/group_detail/components/sub_item.dart';
import 'package:bee/group_detail/group_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class GroupDetailView extends StatelessWidget {
  const GroupDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    final rootProject =
        context.select((GroupDetailBloc bloc) => bloc.state.rootProject);
    final groupID =
        context.select((GroupDetailBloc bloc) => bloc.state.groupID);
    final curGroup =
        context.select((GroupDetailBloc bloc) => bloc.state.curGroup);
    final groupVisible =
        context.select((GroupDetailBloc bloc) => bloc.state.isShowGroup);
    final deviceVisible =
        context.select((GroupDetailBloc bloc) => bloc.state.isShowDevice);
    final childrenGroups =
        context.select((GroupDetailBloc bloc) => bloc.state.childrenGroups);
    final childrenDevices =
        context.select((GroupDetailBloc bloc) => bloc.state.childrenDevices);
    final groupNumber =
        context.select((GroupDetailBloc bloc) => bloc.state.groupNumber);
    final deviceNumber =
        context.select((GroupDetailBloc bloc) => bloc.state.deviceNumber);
    final isAdmin =
        context.select((GroupDetailBloc bloc) => bloc.state.isAdmin);
    final brokerInProjects =
        context.select((GroupDetailBloc bloc) => bloc.state.brokerInProjects);
    final deviceTypeInProjects = context
        .select((GroupDetailBloc bloc) => bloc.state.deviceTypeInProjects);
    final attributes =
        context.select((GroupDetailBloc bloc) => bloc.state.attributes);

    return BlocListener<GroupDetailBloc, GroupDetailState>(
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
                  content: 'Group has deleted successfully',
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
      child: curGroup == null
          ? const SizedBox.shrink()
          : Column(
              children: [
                SizedBox(height: paddingTop),
                _Header(isAdmin: isAdmin),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      const _Title(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isAdmin)
                            TSecondaryButton(
                              label: 'ADD GROUP',
                              onPressed: () => Navigator.of(context).push(
                                EditGroupPage.route(
                                  parentProjetID: null,
                                  parentGroupID: groupID,
                                  initialGroup: null,
                                ),
                              ),
                              enabled: true,
                              textStyle: textTheme.labelLarge!.copyWith(
                                color: ColorName.sky500,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.1,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                        ],
                      ),
                      OptionItem(
                        title: 'Groups',
                        number: groupNumber,
                        unit: 'group',
                        onPressed: () => context.read<GroupDetailBloc>().add(
                              GroupVisibilityChanged(isVisible: !groupVisible),
                            ),
                        visible: groupVisible,
                      ),
                      Column(
                        children: childrenGroups
                            .map(
                              (gr) => Column(
                                children: [
                                  const SizedBox(height: 12),
                                  SubItem(
                                    title: gr.name,
                                    visible: groupVisible,
                                    onPressed: () => Navigator.of(context).push(
                                      GroupDetailPage.route(
                                        isAdmin: isAdmin,
                                        rootProject: rootProject,
                                        groupID: groupID,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      if (isAdmin)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TSecondaryButton(
                              label: 'ADD DEVICE',
                              onPressed: () {
                                Navigator.of(context).push(
                                  EditDevicePage.route(
                                    parentGroupID: groupID,
                                    brokers: brokerInProjects,
                                    deviceTypes: deviceTypeInProjects,
                                    allAttributes: attributes,
                                    initialAttributes: [],
                                    initialDevice: null,
                                    isUseDeviceType: false,
                                    isAdmin: isAdmin,
                                    isEdit: true,
                                  ),
                                );
                              },
                              enabled: true,
                              textStyle: textTheme.labelLarge!.copyWith(
                                color: ColorName.sky500,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.1,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ],
                        ),
                      OptionItem(
                        title: 'Devices',
                        number: deviceNumber,
                        unit: 'devices',
                        onPressed: () => context.read<GroupDetailBloc>().add(
                              DeviceVisibilityChanged(
                                isVisible: !deviceVisible,
                              ),
                            ),
                        visible: deviceVisible,
                      ),
                      Column(
                        children: childrenDevices
                            .map(
                              (dv) => Column(
                                children: [
                                  const SizedBox(height: 12),
                                  SubItem(
                                    title: dv.name,
                                    visible: deviceVisible,
                                    onPressed: () => Navigator.of(context).push(
                                      DeviceDetailPage.route(
                                        rootProject: rootProject,
                                        device: dv,
                                        isAdmin: isAdmin,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
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
    final curGroup =
        context.select((GroupDetailBloc bloc) => bloc.state.curGroup);

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
                context.read<GroupDetailBloc>().add(const DeletionRequested()),
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
            onPressed: () => curGroup == null
                ? () {}
                : Navigator.of(context).push(
                    EditGroupPage.route(
                      parentProjetID: curGroup.projectID,
                      parentGroupID: curGroup.groupID,
                      initialGroup: curGroup,
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
    final curGroup =
        context.select((GroupDetailBloc bloc) => bloc.state.curGroup);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          curGroup?.name ?? '',
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.05,
            color: ColorName.neural700,
          ),
        ),
        const SizedBox(height: 4),
        if (curGroup?.description != null)
          Text(
            curGroup!.description!,
            style: textTheme.labelMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: ColorName.neural600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
