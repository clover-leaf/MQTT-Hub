import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart';

class RecordItem extends StatelessWidget {
  const RecordItem({
    super.key,
    required this.trackingDevice,
    required this.trackingAttributes,
    required this.attributeView,
  });

  final TrackingDevice trackingDevice;
  final List<TrackingAttribute> trackingAttributes;
  final Map<String, Attribute> attributeView;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final attToStrs = <String>[];
    for (final trk in trackingAttributes) {
      final att = attributeView[trk.attributeID];
        if (att != null) {
          attToStrs.add('${att.name}: ${trk.value}');
        }
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.sky100,
        onPrimary: ColorName.sky300,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      onPressed: () {},
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attToStrs.join(', '),
                  style: textTheme.bodyMedium!.copyWith(
                    color: ColorName.neural700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat.yMMMd().add_jms().format(trackingDevice.time),
                  style: textTheme.bodySmall!.copyWith(
                    color: ColorName.neural700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
