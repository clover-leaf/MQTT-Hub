import 'package:bee/tiles_overview/tiles_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class TilesOverviewPage extends StatelessWidget {
  const TilesOverviewPage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: TilesOverviewPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TilesOverviewBloc(context.read<UserRepository>()),
      child: const TilesOverviewView(),
    );
  }
}
