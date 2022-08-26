import 'dart:convert';

import 'package:bee/edit_tile/data/data.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/tiles_overview/painter/painter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class RadialGaugeWidget extends StatelessWidget {
  const RadialGaugeWidget({
    super.key,
    required this.lob,
    required this.value,
    this.unit,
  });

  final String lob;
  final String value;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // decode lob
    // we will get {'ranges':[{'min':0,'max':100,'color':'#123456'}]}
    final decoded = jsonDecode(lob) as Map<String, dynamic>;
    // get ranges
    final ranges = decoded['ranges']! as List<dynamic>;
    // convert ranges to list of GaugeRange
    final gaugeRanges = ranges
        .map((json) => GaugeRange.fromJson(json as Map<String, dynamic>))
        .toList();
    // get global extreme of list of GaugeRange
    final globalMin = double.parse(gaugeRanges.first.min!);
    final globalMax = double.parse(gaugeRanges.last.max!);
    // convert value to angle
    double? angle;
    // value is double
    if (double.tryParse(value) != null) {
      final valueInDouble = double.parse(value);
      angle = (valueInDouble - globalMin) / (globalMax - globalMin);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final centerSpaceRadius = constraints.maxHeight / 2.6;
              return PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: centerSpaceRadius,
                  startDegreeOffset: 45,
                  sections: [
                    PieChartSectionData(
                      color: Colors.transparent,
                      radius: centerSpaceRadius / 4.5,
                      value: 2,
                      showTitle: false,
                    ),
                    ...gaugeRanges.map((ggR) {
                      final color = TileHelper.stringToColor(ggR.color);
                      final min = double.parse(ggR.min!);
                      final max = double.parse(ggR.max!);
                      final value = (max - min) / (globalMax - globalMin) * 6;
                      return PieChartSectionData(
                        radius: centerSpaceRadius / 4.5,
                        showTitle: false,
                        color: color,
                        value: value,
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final paddingTop = height * 0.65;

              late Color textColor;
              if (angle == null) {
                // when value is null or invalid double
                textColor = ColorName.neural700;
              } else if (angle < 0) {
                // when value < global min
                textColor = ColorName.wine500;
              } else if (angle > 1) {
                // when value > global max
                textColor = ColorName.wine500;
              } else {
                // when value is normal
                textColor = ColorName.neural700;
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: paddingTop),
                  Text(
                    angle != null ? value : '?',
                    style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600, color: textColor,),
                  ),
                  if (unit != null)
                    Text(
                      unit!,
                      style: textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorName.sky300,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final centerSpaceRadius = height / 2.6;
              final size = centerSpaceRadius / 1.2;
              final thickness = centerSpaceRadius / 10;
              final centerRadius = centerSpaceRadius / 16;
              final length = height / 5;
              late double radian;
              if (angle == null) {
                // when value is null or invalid double
                radian = -0.375;
              } else if (angle < 0) {
                // when value < global min
                radian = -0.375;
              } else if (angle > 1) {
                // when value > global max
                radian = 0.375;
              } else {
                // when value is normal
                radian = angle * 0.75 - 0.375;
              }
              return AnimatedRotation(
                turns: radian,
                duration: const Duration(milliseconds: 400),
                child: CustomPaint(
                  size: Size(size, size),
                  painter: RadialGaugeNeedle(
                    length: length,
                    thickness: thickness,
                    centerRadius: centerRadius,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
