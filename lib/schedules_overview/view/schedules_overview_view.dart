import 'package:bee/components/component.dart';
import 'package:bee/edit_schedule/view/edit_schedule_page.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/schedules_overview/schedules_overview.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SchedulesOverviewView extends StatelessWidget {
  const SchedulesOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final showedSchedule = context
        .select((SchedulesOverviewBloc bloc) => bloc.state.showedSchedule);
    final parentProject = context
        .select((SchedulesOverviewBloc bloc) => bloc.state.parentProject);
    final isAdmin =
        context.select((SchedulesOverviewBloc bloc) => bloc.state.isAdmin);
    final attributes =
        context.select((SchedulesOverviewBloc bloc) => bloc.state.attributes);
    final deviceInProject = context
        .select((SchedulesOverviewBloc bloc) => bloc.state.deviceInProject);
    final actions =
        context.select((SchedulesOverviewBloc bloc) => bloc.state.actions);
    final paddingTop = MediaQuery.of(context).viewPadding.top;

    return BlocListener<SchedulesOverviewBloc, SchedulesOverviewState>(
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
                  content: 'Schedule has deleted successfully',
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
                ...showedSchedule.map((schedule) {
                  return Column(
                    children: [
                      ScheduleItem(
                        isAdmin: isAdmin,
                        schedule: schedule,
                        onPressed: () {
                          final actionOfSchedule = actions
                              .where((ac) => ac.scheduleID == schedule.id)
                              .toList();
                          Navigator.of(context).push(
                            EditSchedulePage.route(
                              project: parentProject,
                              isAdmin: isAdmin,
                              attributes: attributes,
                              devices: deviceInProject,
                              initialActions: actionOfSchedule,
                              initialSchedule: schedule,
                              isEdit: false,
                            ),
                          );
                        },
                        onDeletePressed: () => context
                            .read<SchedulesOverviewBloc>()
                            .add(DeletionRequested(schedule.id)),
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
        .select((SchedulesOverviewBloc bloc) => bloc.state.parentProject);
    final deviceInProject = context
        .select((SchedulesOverviewBloc bloc) => bloc.state.deviceInProject);
    final attributes =
        context.select((SchedulesOverviewBloc bloc) => bloc.state.attributes);

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
              label: 'ADD SCHEDULE',
              onPressed: () => Navigator.of(context).push(
                EditSchedulePage.route(
                  attributes: attributes,
                  devices: deviceInProject,
                  project: parentProject,
                  initialActions: [],
                  initialSchedule: null,
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
        .select((SchedulesOverviewBloc bloc) => bloc.state.parentProject);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SCHEDULES',
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
