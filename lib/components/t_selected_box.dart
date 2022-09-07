import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TSelectedField extends StatefulWidget {
  const TSelectedField({
    super.key,
    required this.initialValue,
    required this.labelText,
    required this.picture,
    required this.onTapped,
    required this.validator,
    this.enabled = true,
  });

  final String labelText;
  final String? initialValue;
  final SvgGenImage? picture;
  final bool enabled;
  final Future<String?> Function() onTapped;
  final String? Function(String?)? validator;

  @override
  State<TSelectedField> createState() => _TSelectedFieldState();
}

class _TSelectedFieldState extends State<TSelectedField> {
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
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            widget.labelText.toUpperCase(),
            style: textTheme.bodySmall!.copyWith(color: ColorName.neural600),
          ),
        ),
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
            enabled: false,
            // prefix icon
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              errorStyle: textTheme.labelMedium!.copyWith(
                color: ColorName.wine300,
                fontWeight: FontWeight.w700,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 56,
              ),
              prefixIcon: widget.picture != null
                  ? widget.picture!
                      .svg(fit: BoxFit.scaleDown, color: ColorName.neural600)
                  : const SizedBox.shrink(),
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
