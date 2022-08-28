import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/logs_overview/bloc/logs_overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class LogItem extends StatelessWidget {
  const LogItem(this.log, {super.key});

  final Log log;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.watch<LogsOverviewBloc>().state;
    final deviceView = state.deviceView;
    final attributeView = state.attributeView;
    final alertView = state.alertView;
    final conditionLogs = state.conditionLogs;

    final alert = alertView[log.alertID]!;
    final device = deviceView[alert.deviceID]!;
    final conditionLog =
        conditionLogs.where((cdLog) => cdLog.alertLogID == log.id).toList();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.sky100,
        onPrimary: ColorName.sky300,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      onPressed: () {},
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${alert.name} has actived at ${log.time.toString()}' ,
                  style: textTheme.bodyLarge!.copyWith(
                    color: ColorName.neural700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Row(
            //   children: [
            //     _StatItem(
            //       url: broker.url,
            //       port: broker.port.toString(),
            //       image: Assets.icons.global,
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.url,
    required this.port,
    required this.image,
  });

  final String url;
  final String port;
  final SvgGenImage image;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        image.svg(
          fit: BoxFit.scaleDown,
          color: ColorName.neural600,
          height: 18,
          width: 18,
        ),
        const SizedBox(width: 4),
        Text(
          '$url:$port',
          style: textTheme.labelMedium!.copyWith(color: ColorName.sky600),
        ),
      ],
    );
  }
}
