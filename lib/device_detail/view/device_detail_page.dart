import 'package:bee/device_detail/device_detail.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class DeviceDetailPage extends StatelessWidget {
  const DeviceDetailPage({super.key});

  static PageRoute<void> route({
    required Project rootProject,
    required bool isAdmin,
    required Device device,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => DeviceDetailBloc(
          context.read<UserRepository>(),
          rootProject: rootProject,
          device: device,
          isAdmin: isAdmin,
        )
          ..add(const AttributeSubscriptionRequested())
          ..add(const BrokerSubscriptionRequested())
          ..add(const DeviceSubscriptionRequested()),
        child: const DeviceDetailPage(),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
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
      body: DeviceDetailView(),
    );
  }
}
