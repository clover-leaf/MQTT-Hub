import 'package:bee/components/component.dart';
import 'package:bee/edit_schedule/edit_schedule.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DateField extends StatefulWidget {
  const DateField({
    super.key,
    required this.initialDate,
    required this.isRepeat,
    required this.dayOfWeeks,
    required this.enabled,
  });

  final DateTime initialDate;
  final bool isRepeat;
  final List<int> dayOfWeeks;
  final bool enabled;

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  late DateTime _date;
  late bool _isRepeat;
  late List<int> _dayOfWeeks;
  late String _label;
  final dow = {
    0: 'Sun',
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
  };
  final dowLabel = {
    0: 'C',
    1: '2',
    2: '3',
    3: '4',
    4: '5',
    5: '6',
    6: '7',
  };

  @override
  void initState() {
    _date = widget.initialDate;
    _isRepeat = widget.isRepeat;
    _dayOfWeeks = widget.dayOfWeeks;
    _label = dowToString(_dayOfWeeks, _date, isRepeat: _isRepeat);
    super.initState();
  }

  void update(
    BuildContext context,
    List<int> dayOfWeeks,
    DateTime date, {
    required bool isRepeat,
  }) {
    dayOfWeeks.sort();
    context.read<EditScheduleBloc>().add(DateChanged(date));
    context.read<EditScheduleBloc>().add(DayOfWeekChanged(dayOfWeeks));
    context.read<EditScheduleBloc>().add(IsRepeatChanged(isRepeat: isRepeat));
    final newLabel = dowToString(dayOfWeeks, date, isRepeat: isRepeat);
    setState(() {
      _date = date;
      _isRepeat = isRepeat;
      _dayOfWeeks = dayOfWeeks;
      _label = newLabel;
    });
  }

  String dowToString(
    List<int> dayOfWeeks,
    DateTime date, {
    required bool isRepeat,
  }) {
    if (isRepeat) {
      if (dayOfWeeks.length == 7) {
        return 'Every day';
      } else {
        final _dow = dayOfWeeks.map((e) => dow[e]);
        return 'Every ${_dow.join(', ')}';
      }
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: const BoxDecoration(
            color: ColorName.neural200,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Assets.icons.calendar
                      .svg(fit: BoxFit.scaleDown, color: ColorName.neural600),
                  const SizedBox(width: 12),
                  Text(
                    _label,
                    style: textTheme.bodySmall!.copyWith(
                      color: ColorName.neural700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TSecondaryButton(
                    label: 'EDIT',
                    onPressed: () async => showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext bContext) => Container(
                        height: 216,
                        padding: const EdgeInsets.only(top: 6),
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        color: CupertinoColors.systemBackground
                            .resolveFrom(context),
                        child: SafeArea(
                          top: false,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: _date,
                            use24hFormat: true,
                            onDateTimeChanged: (DateTime newDateTime) {
                              update(
                                context,
                                _dayOfWeeks,
                                newDateTime,
                                isRepeat: false,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    enabled: widget.enabled,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  7,
                  (index) => _DowItem(
                    enabled: widget.enabled,
                    label: dowLabel[index]!,
                    isSelected: _dayOfWeeks.contains(index),
                    onPressed: () {
                      final dow = List<int>.from(_dayOfWeeks);
                      if (dow.contains(index)) {
                        dow.remove(index);
                      } else {
                        dow.add(index);
                      }
                      update(context, dow, _date, isRepeat: dow.isNotEmpty);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _DowItem extends StatelessWidget {
  const _DowItem({
    required this.enabled,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final bool enabled;
  final String label;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? ColorName.white : Colors.transparent,
        ),
        child: Text(label),
      ),
    );
  }
}
