import 'package:bee/gen/colors.gen.dart';
import 'package:bee/records_overview/components/tracking_attribute_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart';

class TrackingTab extends StatefulWidget {
  const TrackingTab({
    super.key,
    required this.attributes,
    required this.trackingDevices,
    required this.trackingAttributes,
  });

  final List<Attribute> attributes;
  final List<TrackingDevice> trackingDevices;
  final List<TrackingAttribute> trackingAttributes;

  @override
  State<TrackingTab> createState() => _TrackingTabState();
}

class _TrackingTabState extends State<TrackingTab> {
  late int _index;
  late bool _isFilter;
  DateTime? _startTime;
  DateTime? _endTime;
  late List<TrackingDevice> _trackingDevices;
  late List<TrackingAttribute> _trackingAttributes;
  late List<TrackingDevice> _trackingDevicesFilter;

  @override
  void initState() {
    super.initState();
    _trackingDevices = widget.trackingDevices;
    _trackingAttributes = widget.trackingAttributes;
    _trackingDevicesFilter = widget.trackingDevices;
    _index = 0;
    _isFilter = false;
  }

  @override
  void didUpdateWidget(TrackingTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trackingAttributes != widget.trackingAttributes) {
      setState(() {
        _trackingAttributes = widget.trackingAttributes;
      });
    }
    if (oldWidget.trackingDevices != widget.trackingDevices) {
      setState(() {
        _trackingDevices = widget.trackingDevices;
        _trackingDevicesFilter = widget.trackingDevices;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = widget.attributes
        .map(
          (att) => TrackingAttributeTab(
            attributeID: att.id,
            trackingAttributes: _trackingAttributes,
            trackingDevices: _trackingDevicesFilter,
          ),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isFilter)
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: _DateFilter(
                      label: 'FROM',
                      initialTime: _startTime ??
                          DateTime.now().subtract(const Duration(days: 28)),
                      onChanged: (time) => setState(() {
                        setState(() {
                          _startTime = time;
                        });
                      }),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    fit: FlexFit.tight,
                    child: _DateFilter(
                      label: 'TO',
                      initialTime: _endTime ?? DateTime.now(),
                      onChanged: (time) => setState(() {
                        setState(() {
                          _endTime = time;
                        });
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _Button(
                    label: 'Apply',
                    onPressed: () {
                      var trackingDevicesFilter =
                          List<TrackingDevice>.from(_trackingDevices);
                      if (_endTime != null) {
                        trackingDevicesFilter = _trackingDevices
                            .where((trkDv) => trkDv.time.isBefore(_endTime!))
                            .toList();
                      }
                      if (_startTime != null) {
                        trackingDevicesFilter = trackingDevicesFilter
                            .where((trkDv) => trkDv.time.isAfter(_startTime!))
                            .toList();
                      }
                      setState(() {
                        _trackingDevicesFilter = trackingDevicesFilter;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  _Button(
                    label: 'Clear',
                    onPressed: () => setState(() {
                      _isFilter = false;
                      _startTime = null;
                      _endTime = null;
                      _trackingDevicesFilter = _trackingDevices;
                    }),
                  ),
                ],
              )
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _Button(
                label: 'Filter',
                onPressed: () => setState(() {
                  _isFilter = true;
                  _startTime =
                      DateTime.now().subtract(const Duration(days: 28));
                  _endTime = DateTime.now();
                }),
              ),
            ],
          ),
        SizedBox(
          height: 48,
          child: ListView.separated(
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: widget.attributes.length,
            itemBuilder: (context, index) {
              final att = widget.attributes[index];
              return _TabItem(
                title: att.name,
                isSelected: index == _index,
                onPressed: () => setState(() {
                  _index = index;
                }),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        tabs[_index],
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.sky300,
        onPrimary: ColorName.sky500,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: textTheme.labelMedium!.copyWith(
            color: ColorName.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}

class _DateFilter extends StatelessWidget {
  const _DateFilter({
    required this.onChanged,
    required this.initialTime,
    required this.label,
  });

  final void Function(DateTime) onChanged;
  final DateTime initialTime;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: textTheme.bodySmall!.copyWith(color: ColorName.neural600),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async => showCupertinoModalPopup<void>(
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
                  initialDateTime: initialTime,
                  use24hFormat: true,
                  onDateTimeChanged: onChanged,
                ),
              ),
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: ColorName.neural600),
            ),
            child: Text(
              DateFormat.yMMMd().add_jm().format(initialTime),
              style: textTheme.bodyMedium!.copyWith(
                fontSize: 13,
                color: ColorName.neural700,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.title,
    required this.isSelected,
    required this.onPressed,
  });

  final String title;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: Colors.transparent,
        onPrimary: ColorName.sky300,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: isSelected ? ColorName.sky600 : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          title,
          style: textTheme.bodyMedium!.copyWith(
            color: isSelected ? ColorName.sky700 : ColorName.neural500,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.02,
          ),
        ),
      ),
    );
  }
}
