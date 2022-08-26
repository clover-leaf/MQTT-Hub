import 'dart:convert';

import 'package:bee/edit_tile/data/data.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/tiles_overview/painter/linear_gauge_needle.dart';
import 'package:bee/tiles_overview/painter/linear_gauge_ruler.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class LinearGaugeWidget extends StatelessWidget {
  const LinearGaugeWidget({
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
    // convert value to offset
    double? offset;
    // value is double
    if (double.tryParse(value) != null) {
      final valueInDouble = double.parse(value);
      offset = (valueInDouble - globalMin) / (globalMax - globalMin);
    }
    // generate ranges for line_gauge_ruler
    final rulerRanges = gaugeRanges.map<Map<String, dynamic>>((ggR) {
      final color = TileHelper.stringToColor(ggR.color);
      final min = double.parse(ggR.min!);
      final max = double.parse(ggR.max!);
      final range = max - min;
      return {'color': color, 'range': range};
    }).toList();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AspectRatio(
          aspectRatio: 2.2,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              final unitLength = width / (globalMax - globalMin);
              final thickness = height / 10;
              final paddingTop = height * 0.3;
              return CustomPaint(
                size: Size(width, height),
                painter: LinearGaugeRuler(
                  ranges: rulerRanges,
                  unitLength: unitLength,
                  thickness: thickness,
                  paddingTop: paddingTop,
                ),
              );
            },
          ),
        ),
        AspectRatio(
          aspectRatio: 2.2,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final paddingTop = height * 0.5;
              late Color textColor;
              if (offset == null) {
                // when value is null or invalid double
                textColor = ColorName.neural700;
              } else if (offset < 0) {
                // when value < global min
                textColor = ColorName.wine500;
              } else if (offset > 1) {
                // when value > global max
                textColor = ColorName.wine500;
              } else {
                // when value is normal
                textColor = ColorName.neural700;
              }
              return Column(
                children: [
                  SizedBox(height: paddingTop),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text(
                        offset != null ? value : '?',
                        style: textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      if (unit != null) const SizedBox(width: 8),
                      if (unit != null)
                        Text(
                          unit!,
                          style: textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorName.sky300,
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        AspectRatio(
          aspectRatio: 2.2,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final width = constraints.maxWidth;
              final paddingTop = height * 0.1;
              final length = height / 10 + 4;
              late double paddingLeft;
              if (offset == null) {
                // when value is null or invalid double
                paddingLeft = 0;
              } else if (offset < 0) {
                // when value < global min
                paddingLeft = 0;
              } else if (offset > 1) {
                // when value > global max
                paddingLeft = width;
              } else {
                // when value is normal
                paddingLeft = offset * width;
              }
              return AnimatedContainer(
                padding: EdgeInsets.fromLTRB(
                  paddingLeft,
                  paddingTop,
                  0,
                  0,
                ),
                duration: const Duration(milliseconds: 400),
                child: CustomPaint(painter: LinearGaugeNeedle(length: length)),
              );
            },
          ),
        )
      ],
    );
  }
}
