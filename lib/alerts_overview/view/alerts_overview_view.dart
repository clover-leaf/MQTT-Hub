import 'package:bee/alerts_overview/alerts_overview.dart';
import 'package:bee/components/component.dart';
import 'package:bee/edit_alert/view/edit_alert_page.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AlertsOverviewView extends StatelessWidget {
  const AlertsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final showedAlerts =
        context.select((AlertsOverviewBloc bloc) => bloc.state.showedAlerts);
    final isAdmin =
        context.select((AlertsOverviewBloc bloc) => bloc.state.isAdmin);
    final conditions =
        context.select((AlertsOverviewBloc bloc) => bloc.state.conditions);
    final actions =
        context.select((AlertsOverviewBloc bloc) => bloc.state.actions);
    final deviceInProject =
        context.select((AlertsOverviewBloc bloc) => bloc.state.deviceInProject);
    final attributeInProject = context
        .select((AlertsOverviewBloc bloc) => bloc.state.attributeInProject);
    final paddingTop = MediaQuery.of(context).viewPadding.top;

    return BlocListener<AlertsOverviewBloc, AlertsOverviewState>(
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
                  content: 'Alert has deleted successfully',
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
                ...showedAlerts.map((al) {
                  return Column(
                    children: [
                      AlertItem(
                        isAdmin: isAdmin,
                        alert: al,
                        onPressed: () {
                          final conditionOfAlert = conditions
                              .where((cd) => cd.alertID == al.id)
                              .toList();
                          final actionOfAlert = actions
                              .where((ac) => ac.alertID == al.id)
                              .toList();
                          Navigator.of(context).push(
                            EditAlertPage.route(
                              attributes: attributeInProject,
                              devices: deviceInProject,
                              initialConditions: conditionOfAlert,
                              initialActions: actionOfAlert,
                              initialAlert: al,
                            ),
                          );
                        },
                        onDeletePressed: () => context
                            .read<AlertsOverviewBloc>()
                            .add(DeletionRequested(al.id)),
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
    final deviceInProject =
        context.select((AlertsOverviewBloc bloc) => bloc.state.deviceInProject);
    final attributeInProject = context
        .select((AlertsOverviewBloc bloc) => bloc.state.attributeInProject);

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
              label: 'ADD ALERT',
              onPressed: () => Navigator.of(context).push(
                EditAlertPage.route(
                  attributes: attributeInProject,
                  devices: deviceInProject,
                  initialConditions: [],
                  initialActions: [],
                  initialAlert: null,
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
        context.select((AlertsOverviewBloc bloc) => bloc.state.parentProject);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'alerts'.toUpperCase(),
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
