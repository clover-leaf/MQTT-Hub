import 'package:bee/edit_device/bloc/bloc.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QosField extends StatefulWidget {
  const QosField({
    super.key,
    required this.initialQos,
    required this.enabled,
  });

  final int initialQos;
  final bool enabled;

  @override
  State<QosField> createState() => _QosFieldState();
}

class _QosFieldState extends State<QosField> {
  late int? _qos;

  @override
  void initState() {
    _qos = widget.initialQos;
    super.initState();
  }

  void updateBloc(BuildContext context, int qos) {
    context.read<EditDeviceBloc>().add(QosChanged(qos));
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: _qos,
      validator: (_) => null,
      builder: (_) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: ColorName.neural700),
        ),
        child: Row(
          children: [
            _QosItem(
              label: 'QoS 0',
              enabled: widget.enabled,
              onPressed: () {
                updateBloc(context, 0);
                setState(() {
                  _qos = 0;
                });
              },
              isSelected: 0 == _qos,
            ),
            _QosItem(
              label: 'QoS 1',
              enabled: widget.enabled,
              onPressed: () {
                updateBloc(context, 1);
                setState(() {
                  _qos = 1;
                });
              },
              isSelected: 1 == _qos,
            ),
            _QosItem(
              label: 'QoS 2',
              enabled: widget.enabled,
              onPressed: () {
                updateBloc(context, 2);
                setState(() {
                  _qos = 2;
                });
              },
              isSelected: 2 == _qos,
            ),
          ],
        ),
      ),
    );
  }
}

class _QosItem extends StatelessWidget {
  const _QosItem({
    required this.label,
    required this.onPressed,
    required this.isSelected,
    required this.enabled,
  });

  final String label;
  final void Function() onPressed;
  final bool isSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // get text theme of context
    final textTheme = Theme.of(context).textTheme;
    return Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onPressed : () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? ColorName.sky500 : Colors.transparent,
          ),
          child: Text(
            label,
            style: textTheme.bodySmall!.copyWith(
              color: isSelected ? ColorName.white : ColorName.neural700,
            ),
          ),
        ),
      ),
    );
  }
}
