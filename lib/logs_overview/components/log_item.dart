import 'package:bee/gen/colors.gen.dart';
import 'package:bee/logs_overview/bloc/logs_overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
    final conditionView = state.conditionView;
    final conditionLogs = state.conditionLogs;

    final alert = alertView[log.alertID]!;
    final device = deviceView[alert.deviceID]!;
    final conditionLog =
        conditionLogs.where((cdLog) => cdLog.alertLogID == log.id).toList();

    final conditionLogString = <String>[];
    for (final cdLog in conditionLog) {
      final condition = conditionView[cdLog.conditionID];
      final value = cdLog.value;
      final attribute = attributeView[condition?.attributeID];
      String? comparison;
      switch (condition?.comparison) {
        case Comparison.g:
          comparison = '>';
          break;
        case Comparison.geq:
          comparison = '≥';
          break;
        case Comparison.eq:
          comparison = '≡';
          break;
        case Comparison.leq:
          comparison = '≤';
          break;
        case Comparison.l:
          comparison = '>';
          break;
        case null:
          break;
      }
      if (condition != null && attribute != null && comparison != null) {
        conditionLogString.add(
          'Condition of ${device.name}: ${attribute.name} $comparison '
          '${condition.value} has active with value $value',
        );
      }
    }
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
      onPressed: () => showDialog<void>(
        context: context,
        builder: (bContext) => _LogDialog(
          log: log,
          alert: alert,
          conditionLogString: conditionLogString,
        ),
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${alert.name} has actived',
              style: textTheme.bodyLarge!.copyWith(
                color: ColorName.neural700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat.yMMMd().add_jms().format(log.time),
              style: textTheme.bodySmall!.copyWith(
                color: ColorName.neural600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogDialog extends StatelessWidget {
  const _LogDialog({
    required this.log,
    required this.alert,
    required this.conditionLogString,
  });

  final Log log;
  final Alert alert;
  final List<String> conditionLogString;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      elevation: 0,
      backgroundColor: ColorName.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 18, 32, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${alert.name} has actived',
              style: textTheme.bodyLarge!.copyWith(
                color: ColorName.neural700,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              DateFormat.yMMMd().add_jms().format(log.time),
              style: textTheme.bodySmall!.copyWith(
                color: ColorName.neural600,
              ),
            ),
            const SizedBox(height: 8),
            ...conditionLogString.map(
              (str) => Flexible(
                child: Text(
                  str,
                  style:
                      textTheme.bodySmall!.copyWith(color: ColorName.neural700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
