import 'package:bee/components/component.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/logs_overview/bloc/bloc.dart';
import 'package:bee/logs_overview/components/log_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class LogsOverviewView extends StatelessWidget {
  const LogsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LogsOverviewBloc>().state;
    final logs = state.logs;
    final sortedLogs = List<Log>.from(logs)
      ..sort((a, b) => b.time.compareTo(a.time));

    final paddingTop = MediaQuery.of(context).viewPadding.top;

    return Column(
      children: [
        SizedBox(height: paddingTop),
        const _Header(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const _Title(),
              const SizedBox(height: 20),
              ...sortedLogs.map((log) {
                return Column(
                  children: [
                    LogItem(log),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList()
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ALERT LOGS',
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.05,
            color: ColorName.neural700,
          ),
        ),
      ],
    );
  }
}
