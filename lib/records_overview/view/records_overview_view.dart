import 'package:bee/components/component.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/records_overview/components/tracking_tab.dart';
import 'package:bee/records_overview/records_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RecordsOverviewView extends StatelessWidget {
  const RecordsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final trackingDevices = context
        .select((RecordsOverviewBloc bloc) => bloc.state.trackingDevices);
    final trackingAttributes = context
        .select((RecordsOverviewBloc bloc) => bloc.state.trackingAttributes);
    final attributes =
        context.select((RecordsOverviewBloc bloc) => bloc.state.attributes);
    final paddingTop = MediaQuery.of(context).viewPadding.top;

    return BlocListener<RecordsOverviewBloc, RecordsOverviewState>(
      listener: (context, state) {
        if (state.status.isProcessing()) {
          context.loaderOverlay.show();
        } else {
          if (state.status.isSuccess()) {
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
          const _Header(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Title(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: TrackingTab(
                      attributes: attributes,
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
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TCircleButton(
          picture: Assets.icons.arrowLeft
              .svg(color: ColorName.neural700, fit: BoxFit.scaleDown),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final device =
        context.select((RecordsOverviewBloc bloc) => bloc.state.device);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TRACKING DATA',
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.05,
            color: ColorName.neural700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          device.name,
          style: textTheme.labelMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorName.neural600,
          ),
        ),
      ],
    );
  }
}
