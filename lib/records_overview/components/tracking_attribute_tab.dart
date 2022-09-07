// ignore_for_file: unused_import

import 'package:bee/gen/colors.gen.dart';
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
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: trackingDevices.map((trkDv) {
          final trackingAtt = trackingTAttView[trkDv.id];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
        }).toList(),
      ),
    );
  }
}
