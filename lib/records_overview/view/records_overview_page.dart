import 'package:bee/gen/colors.gen.dart';
import 'package:bee/records_overview/records_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class RecordsOverviewPage extends StatelessWidget {
  const RecordsOverviewPage({super.key});

  static PageRoute<void> route({
    required Device device,
    required List<Attribute> attributes,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => RecordsOverviewBloc(
          context.read<UserRepository>(),
          device: device,
          attributes: attributes,
        )..add(const GetRecords()),
        child: const RecordsOverviewPage(),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorName.white,
      body: RecordsOverviewView(),
    );
  }
}
