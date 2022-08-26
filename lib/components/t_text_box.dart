import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TTextBox extends StatefulWidget {
  const TTextBox({
    super.key,
    required this.initialText,
    required this.label,
    required this.hintText,
    required this.prefix,
    required this.onChanged,
    required this.readOnly,
    this.suffix,
    this.rightTitleButton,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
  });

  final String label;
  final String hintText;
  final String? initialText;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final void Function(String) onChanged;
  final Widget? rightTitleButton;
  final TextInputType textInputType;
  final bool obscureText;

  @override
  State<TTextBox> createState() => _TTextBoxState();
}

class _TTextBoxState extends State<TTextBox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if (widget.initialText != null) {
      _controller.text = widget.initialText!;
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.rightTitleButton != null) widget.rightTitleButton!
              ],
            ),
          ),
          TextFormField(
            keyboardType: widget.textInputType,
            controller: _controller,
            obscureText: widget.obscureText,
            onChanged: widget.onChanged,
            cursorColor: ColorName.lavender,
            style: textTheme.labelLarge,
            readOnly: widget.readOnly,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: textTheme.labelLarge!.copyWith(
                color: ColorName.sky300,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorName.gray),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorName.sky300),
                borderRadius: BorderRadius.circular(4),
              ),
              prefixIcon: widget.prefix,
              suffixIcon: widget.suffix,
            ),
          ),
        ],
      ),
    );
  }
}
