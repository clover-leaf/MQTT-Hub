import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TVanillaText extends StatefulWidget {
  const TVanillaText({
    super.key,
    required this.initText,
    required this.hintText,
    required this.onChanged,
    required this.validator,
    this.enabled = true,
    this.textInputType = TextInputType.text,
  });

  final String hintText;
  final String? initText;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType textInputType;

  @override
  State<TVanillaText> createState() => _TVanillaTextState();
}

class _TVanillaTextState extends State<TVanillaText> {
  late TextEditingController _controller;
  late bool hasFocus;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if (widget.initText != null && widget.initText!.isNotEmpty) {
      _controller.text = widget.initText!;
    }
    hasFocus = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Focus(
      onFocusChange: (focus) => setState(() {
        hasFocus = focus;
      }),
      child: TextFormField(
        validator: (value) {
          if (hasFocus) {
            return null;
          } else {
            return widget.validator?.call(value);
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: widget.textInputType,
        controller: _controller,
        onChanged: widget.onChanged,
        cursorColor: ColorName.sky300,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        style: textTheme.bodyMedium!.copyWith(
          color: ColorName.neural700,
          fontWeight: FontWeight.w600,
        ),
        enabled: widget.enabled,
        // prefix icon
        decoration: InputDecoration(
          errorStyle: textTheme.labelMedium!
              .copyWith(color: ColorName.wine300, fontWeight: FontWeight.w700),
          // background
          filled: true,
          fillColor: hasFocus ? ColorName.neural300 : ColorName.neural200,
          // label
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: widget.hintText,
          hintStyle: textTheme.bodyMedium!.copyWith(
            color: hasFocus
                ? (widget.enabled ? ColorName.neural600 : ColorName.sky300)
                : (widget.enabled ? ColorName.neural600 : ColorName.neural400),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            borderSide: BorderSide(color: ColorName.neural500, width: 3),
          ),
          disabledBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            borderSide: BorderSide(color: ColorName.neural300, width: 3),
          ),
          enabledBorder: const UnderlineInputBorder(
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
    );
  }
}
