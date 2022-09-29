// ignore_for_file: unused_import

import 'package:bee/gen/colors.gen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart';

class TrackingAttributeTab extends StatelessWidget {
  const TrackingAttributeTab({
    super.key,
    required this.trackingDevices,
    required this.trackingAttributes,
    required this.attributeID,
  });

  final List<TrackingDevice> trackingDevices;
  final List<TrackingAttribute> trackingAttributes;
  final String attributeID;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final trackingTAtt = trackingAttributes
        .where((trkA) => trkA.attributeID == attributeID)
        .toList();
    final trackingTAttView = {
      for (final att in trackingTAtt) att.trackingDeviceID: att
    };
    final showedTrackingAtt = trackingDevices.map((trkDv) {
      final trackingAtt = trackingTAttView[trkDv.id];
      if (trackingAtt != null && double.tryParse(trackingAtt.value) != null) {
        return FlSpot(
          trkDv.time.millisecondsSinceEpoch.toDouble(),
          double.parse(trackingAtt.value),
        );
      } else {
        return FlSpot(trkDv.time.millisecondsSinceEpoch.toDouble(), 0);
      }
    }).toList();
    return Expanded(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            getTitlesWidget: (value, meta) => Text(
                              value.toString(),
                              style: const TextStyle(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                            reservedSize: 44,
                            showTitles: true,
                            interval: showedTrackingAtt.isNotEmpty ? showedTrackingAtt.length.toDouble() : 1,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          bottom: BorderSide(color: ColorName.neural500),
                          left: BorderSide(color: ColorName.neural500),
                          right: BorderSide(color: Colors.transparent),
                          top: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: false,
                          isStrokeCapRound: false,
                          dotData: FlDotData(show: false),
                          color: ColorName.neural600,
                          spots: showedTrackingAtt,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ...trackingDevices.map((trkDv) {
                    final trackingAtt = trackingTAttView[trkDv.id];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: ColorName.neural600),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            trackingAtt?.value ?? 'N/A',
                            style: textTheme.bodyMedium!.copyWith(fontSize: 13),
                          ),
                          Text(
                            DateFormat.yMMMd().add_jms().format(trkDv.time),
                            style: textTheme.bodyMedium!.copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
