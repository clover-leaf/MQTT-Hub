import 'package:bee/tiles_overview/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TilesOverviewView extends StatelessWidget {
  const TilesOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TilesOverviewBloc>().state;

    return MultiBlocListener(
      listeners: [
        BlocListener<TilesOverviewBloc, TilesOverviewState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {},
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 32,
        ),
        children: const [_Header()],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ahihi',
            style: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Lonely',
            style: textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
