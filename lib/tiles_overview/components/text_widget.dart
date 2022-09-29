import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatefulWidget {
  const TextWidget({
    super.key,
    required this.value,
    required this.unit,
  });

  final String value;
  final String? unit;

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  late String _showedValue;
  late String? _unit;
  // whether latest value is greater or smaller than previous
  bool? _isUpTrend;
  // the deviant of latest and previous in percent
  double? _deviant;
  // latest value
  double? _lastValue;

  @override
  void initState() {
    _showedValue = widget.value;
    _unit = widget.unit;
    if (double.tryParse(widget.value) != null) {
      _lastValue = double.parse(widget.value);
    }
    super.initState();
  }

  void _updateValue(String latestValue) {
    if (double.tryParse(latestValue) != null) {
      final latestValueDouble = double.parse(latestValue);
      if (_lastValue != null) {
        setState(() {
          _isUpTrend = latestValueDouble > _lastValue!;
          _deviant =
              (latestValueDouble - _lastValue!).abs() / _lastValue! * 100;
        });
      }
      setState(() {
        _lastValue = latestValueDouble;
      });
    }
    setState(() {
      _showedValue = latestValue;
    });
  }

  void _updateUnit(String? unit) {
    setState(() {
      _unit = unit;
    });
  }

  @override
  void didUpdateWidget(TextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateValue(widget.value);
    if (oldWidget.unit != widget.unit) {
      _updateUnit(widget.unit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AspectRatio(
      aspectRatio: 2.2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;
          final paddingHorizontal = width * 0.05;
          final paddingVertical = height * 0.15;
          // get trend indicator
          SvgGenImage? picture;
          Color? trendColor;
          if (_isUpTrend != null) {
            if (_isUpTrend!) {
              picture = Assets.icons.arrowUp;
              trendColor = ColorName.pine400;
            } else {
              picture = Assets.icons.arrowDown2;
              trendColor = ColorName.wine400;
            }
          }
          // get percent devian
          String? percentDeviant;
          if (_deviant != null) {
            percentDeviant = _deviant!.toStringAsFixed(1);
          }
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: paddingVertical,
              horizontal: paddingHorizontal,
            ),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      _showedValue,
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorName.neural700,
                      ),
                    ),
                    if (picture != null)
                      picture.svg(
                        fit: BoxFit.scaleDown,
                        color: trendColor,
                        height: 18,
                        width: 18,
                      ),
                    if (percentDeviant != null)
                      Text(
                        '$percentDeviant %',
                        style:
                            textTheme.titleSmall!.copyWith(color: trendColor),
                      )
                  ],
                ),
                if (_unit != null)
                  Text(
                    _unit!,
                    style: textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorName.sky300,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
