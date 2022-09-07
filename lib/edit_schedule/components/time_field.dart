import 'package:bee/edit_schedule/edit_schedule.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeField extends StatefulWidget {
  const TimeField({
    super.key,
    required this.initialTime,
    required this.enabled,
  });

  final TimeOfDay initialTime;
  final bool enabled;

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  late TimeOfDay _time;

  @override
  void initState() {
    _time = widget.initialTime;
    super.initState();
  }

  void updateBloc(BuildContext context, DateTime time) {
    context.read<EditScheduleBloc>().add(TimeChanged(time));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            if (widget.enabled) {
              await showCupertinoModalPopup<void>(
                context: context,
                builder: (BuildContext bContext) => Container(
                  height: 216,
                  padding: const EdgeInsets.only(top: 6),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  // Provide a background color for the popup.
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  // Use a SafeArea widget to avoid system overlaps.
                  child: SafeArea(
                    top: false,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: DateTime(
                        now.year,
                        now.month,
                        now.day,
                        _time.hour,
                        _time.minute,
                      ),
                      use24hFormat: true,
                      // This is called when the user changes the dateTime.
                      onDateTimeChanged: (DateTime newTime) {
                        updateBloc(context, newTime);
                        setState(
                          () => _time = TimeOfDay(
                            hour: newTime.hour,
                            minute: newTime.minute,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: const BoxDecoration(
              color: ColorName.neural200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Assets.icons.clock
                    .svg(fit: BoxFit.scaleDown, color: ColorName.neural600),
                const SizedBox(width: 12),
                Text(
                  '${_time.hour.toString().padLeft(2, '0')}'
                  ':${_time.minute.toString().padLeft(2, '0')}',
                  style: textTheme.bodyMedium!.copyWith(
                    color: ColorName.neural700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
