import 'dart:convert';

import 'package:bee/edit_tile/data/data.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarWidget extends StatefulWidget {
  const BarWidget({
    super.key,
    required this.lob,
    required this.value,
    this.unit,
  });

  final String lob;
  final String value;
  final String? unit;

  @override
  State<BarWidget> createState() => _BarWidgetState();
}

class _BarWidgetState extends State<BarWidget> {
  final maxLength = 10;
  // values for build chart
  List<double> _values = [];
  // whether latest value is greater or smaller than previous
  bool? _isUpTrend;
  // the deviant of latest and previous in percent
  double? _deviant;
  // color of chart
  late Color _color;
  // unit of chart
  late String? _unit;

  @override
  void initState() {
    super.initState();
    _unit = widget.unit;
    _updateColor(widget.lob);
    _updateValue(widget.value);
  }

  void _updateValue(String latestValue) {
    if (double.tryParse(latestValue) != null) {
      final latestValueDouble = double.parse(latestValue);
      final values = List<double>.from(_values);
      if (values.isNotEmpty) {
        final lastValue = values.last;
        // update trend
        setState(() {
          _isUpTrend = latestValueDouble > lastValue;
          _deviant = (latestValueDouble - lastValue).abs() / lastValue * 100;
        });
        // keep values length is not exceed max
        if (values.length == maxLength) {
          values.removeAt(0);
        }
        values.add(latestValueDouble);
        setState(() {
          _values = values;
        });
      } else {
        // values is empty
        values.add(latestValueDouble);
        setState(() {
          _values = values;
        });
      }
    }
  }

  void _updateColor(String lob) {
    final decoded = jsonDecode(lob) as Map<String, dynamic>;
    final color = decoded['color'] as String;
    setState(() {
      _color = TileHelper.stringToColor(color);
    });
  }

  void _updateUnit(String? unit) {
    setState(() {
      _unit = unit;
    });
  }

  @override
  void didUpdateWidget(BarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _updateValue(widget.value);
    }
    if (oldWidget.lob != widget.lob) {
      _updateColor(widget.lob);
    }
    if (oldWidget.unit != widget.unit) {
      _updateUnit(widget.unit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.6,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final width = constraints.maxWidth;
              final paddingHorizontal = width * 0.05;
              final paddingVertical = height * 0.15;
              final barWidth = (width * 0.9) / 28;
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: paddingVertical,
                  horizontal: paddingHorizontal,
                ),
                child: BarChart(
                  BarChartData(
                    // groupsSpace: 60,
                    alignment: BarChartAlignment.start,
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    barGroups: List.generate(
                      28,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: index.remainder(3) == 0 &&
                                    index ~/ 3 < _values.length
                                ? _values[index ~/ 3]
                                : 0,
                            color: _color,
                            width: barWidth,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        AspectRatio(
          aspectRatio: 2.3,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final width = constraints.maxWidth;
              final paddingHorizontal = width * 0.05;
              final paddingVertical = height * 0.15;
              // get latest value
              final value = _values.last.toString();
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
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: paddingVertical,
                  horizontal: paddingHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          value,
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
                            style: textTheme.titleSmall!.copyWith(
                              color: trendColor,
                              fontWeight: FontWeight.w600,
                            ),
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
        ),
      ],
    );
  }
}
