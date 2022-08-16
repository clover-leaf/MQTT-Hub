import 'package:bee/edit_device/edit_device.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class EditDevicePage extends StatelessWidget {
  const EditDevicePage({super.key});

  static PageRoute<void> route({
    required String path,
    required Project rootProject,
    required Group parentGroup,
    required List<Attribute> initAttributes,
    required Device? initDevice,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => EditDeviceBloc(
          context.read<UserRepository>(),
          path: path,
          rootProject: rootProject,
          parentGroup: parentGroup,
          initAttributes: initAttributes,
          initDevice: initDevice,
        )..add(const BrokerSubscriptionRequested()),
        child: const EditDevicePage(),
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
    final theme = Theme.of(context);
    final state = context.watch<EditDeviceBloc>().state;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorName.blue,
        splashColor: ColorName.darkBlue,
        foregroundColor: ColorName.darkBlue,
        onPressed: () => context.read<EditDeviceBloc>().add(
              EditSubmitted(
                deviceName: state.deviceName.value,
                topicName: state.topicName.value,
                selectedBrokerID: state.selectedBrokerID,
              ),
            ),
        child: Assets.icons.folderAdd.svg(color: ColorName.white),
      ),
      bottomNavigationBar: BottomAppBar(
        color: theme.backgroundColor,
        elevation: 24,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: const CircleBorder(),
                  primary: ColorName.white,
                  onPrimary: ColorName.blue,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(16),
                ),
                child: Assets.icons.arrowLeft.svg(),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: const CircleBorder(),
                  primary: ColorName.white,
                  onPrimary: ColorName.blue,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(16),
                ),
                child: Assets.icons.lock.svg(),
              ),
            ],
          ),
        ),
      ),
      body: const EditDeviceView(),
    );
  }
}
