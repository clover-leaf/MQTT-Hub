import 'package:bee/components/component.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class AttributeSheet extends StatelessWidget {
  const AttributeSheet({
    super.key,
    required this.onAttributeSeleted,
    required this.attributes,
    required this.selectedAttributeID,
  });

  final void Function(Attribute) onAttributeSeleted;
  final List<Attribute> attributes;
  final String? selectedAttributeID;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      decoration: const BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 28),
            child: Text(
              'ATTRIBUTES',
              style: textTheme.titleSmall,
            ),
          ),
          if (attributes.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              alignment: Alignment.center,
              height: 96,
              child: Text(
                'There is no attribute in this device',
                style: textTheme.titleSmall,
              ),
            )
          else
            ...attributes.map(
              (att) => TBrokerItem(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                title: att.name,
                subtitle: att.jsonPath,
                isSelected: att.id == selectedAttributeID,
                onPressed: () => onAttributeSeleted(att),
              ),
            )
        ],
      ),
    );
  }
}
