import 'package:bee/edit_schedule/edit_schedule.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class EditSchedulePage extends StatelessWidget {
  const EditSchedulePage({
    super.key,
    required this.initialID,
    required this.initialSchedule,
    required this.devices,
    required this.attributes,
    required this.initialActions,
    required this.initialDayOfWeeks,
  });

  final String initialID;
  final Schedule? initialSchedule;
  final List<Device> devices;
  final List<Attribute> attributes;
  final List<TAction> initialActions;
  final List<int> initialDayOfWeeks;

  static PageRoute<void> route({
    required Project project,
    required List<Attribute> attributes,
    required List<Device> devices,
    required List<TAction> initialActions,
    required Schedule? initialSchedule,
    required bool isAdmin,
    required bool isEdit,
  }) {
    final initialID = initialSchedule?.id ?? const Uuid().v4();
    final dow = initialSchedule?.dayOfWeeks != null &&
            initialSchedule!.dayOfWeeks.isNotEmpty
        ? initialSchedule.dayOfWeeks.split(',').map(int.parse).toList()
        : <int>[];
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => EditScheduleBloc(
          context.read<UserRepository>(),
          isAdmin: isAdmin,
          isEdit: isEdit,
          devices: devices,
          attributes: attributes,
          initialID: initialID,
          initialActions: initialActions,
          parentProject: project,
          initialSchedule: initialSchedule,
          dayOfWeeks: dow,
        ),
        child: EditSchedulePage(
          initialID: initialID,
          initialSchedule: initialSchedule,
          devices: devices,
          attributes: attributes,
          initialActions: initialActions,
          initialDayOfWeeks: dow,
        ),
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
    return Scaffold(
      backgroundColor: ColorName.white,
      body: EditScheduleView(
        initialSchedule: initialSchedule,
        initialID: initialID,
        devices: devices,
        attributes: attributes,
        initialActions: initialActions,
        initialDayOfWeeks: initialDayOfWeeks,
      ),
    );
  }
}
