import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TSelectedVanilla extends StatefulWidget {
  const TSelectedVanilla({
    super.key,
    required this.initialValue,
    required this.onTapped,
    required this.validator,
    this.enabled = true,
  });

  final String? initialValue;
  final Future<String?> Function() onTapped;
  final String? Function(String?)? validator;
  final bool enabled;

  @override
  State<TSelectedVanilla> createState() => _TSelectedVanillaState();
}

class _TSelectedVanillaState extends State<TSelectedVanilla> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            if (widget.enabled) {
              final value = await widget.onTapped();
              setState(() {
                if (value != null) {
                  _controller.text = value;
                }
              });
            }
          },
          child: TextFormField(
            validator: (value) => widget.validator?.call(value),
            controller: _controller,
            cursorColor: ColorName.sky300,
            style: textTheme.bodyMedium!.copyWith(
              color: ColorName.neural700,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            enabled: false,
            // prefix icon
            decoration: InputDecoration(
              // contentPadding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              errorStyle: textTheme.labelMedium!.copyWith(
                color: ColorName.wine300,
                fontWeight: FontWeight.w700,
              ),
              // background
              filled: true,
              fillColor: ColorName.neural200,
              // label
              disabledBorder: const UnderlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                borderSide: BorderSide(color: ColorName.neural400, width: 3),
              ),
              errorBorder: const UnderlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                borderSide: BorderSide(color: ColorName.wine300, width: 3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
