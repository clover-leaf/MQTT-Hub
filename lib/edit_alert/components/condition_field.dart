import 'package:bee/components/component.dart';
import 'package:bee/edit_alert/edit_alert.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class ConditionField extends StatefulWidget {
  const ConditionField({
    super.key,
    required this.initialConditions,
    required this.attributes,
    required this.alertID,
    required this.onConditionsChanged,
    required this.enabled,
  });

  final List<Condition> initialConditions;
  final List<Attribute> attributes;
  final String alertID;
  final void Function(List<Condition>) onConditionsChanged;
  final bool enabled;

  @override
  State<ConditionField> createState() => _ConditionFieldState();
}

class _ConditionFieldState extends State<ConditionField> {
  late List<Condition> _conditions;
  late Map<String, Attribute> _attributeView;

  @override
  void initState() {
    _conditions = widget.initialConditions;
    _attributeView = {for (final att in widget.attributes) att.id: att};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FormField(
      initialValue: _conditions,
      validator: (_) {
        if (_conditions.isEmpty) {
          return 'Alert must have at least one condition';
        }
        return null;
      },
      builder: (conditionFormFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CONDITION LIST',
                style:
                    textTheme.bodySmall!.copyWith(color: ColorName.neural600),
              ),
              TAddButton(
                label: 'ADD CONDITION',
                enabled: widget.enabled,
                onPressed: () {
                  final cd = Condition(
                    id: const Uuid().v4(),
                    alertID: widget.alertID,
                    attributeID: '',
                    comparison: Comparison.g,
                    value: '',
                  );
                  final conditions = [..._conditions, cd];
                  widget.onConditionsChanged(conditions);
                  setState(() {
                    _conditions = conditions;
                  });
                },
              )
            ],
          ),
          Text(
            'The relationship between conditions is AND',
            style: textTheme.bodySmall!.copyWith(color: ColorName.neural500),
          ),
          const SizedBox(height: 8),
          ...List.generate(_conditions.length, (index) {
            final cd = _conditions[index];
            final attributeID = cd.attributeID;
            final comparison = cd.comparison;
            final value = cd.value;
            final attribute = _attributeView[attributeID];
            return Column(
              children: [
                _CondtionItem(
                  index: index,
                  attributes: widget.attributes,
                  attribute: attribute,
                  comparison: comparison,
                  conditions: _conditions,
                  value: value,
                  onSaved: (conditions) {
                    widget.onConditionsChanged(conditions);
                  },
                  enabled: widget.enabled,
                ),
                const SizedBox(height: 12)
              ],
            );
          }),
          // List ranges error line
          if (conditionFormFieldState.hasError)
            Text(
              conditionFormFieldState.errorText!,
              style: textTheme.labelMedium!.copyWith(
                color: ColorName.wine300,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _CondtionItem extends StatelessWidget {
  const _CondtionItem({
    required this.index,
    required this.conditions,
    required this.attributes,
    required this.attribute,
    required this.comparison,
    required this.value,
    required this.onSaved,
    required this.enabled,
  });

  final int index;
  final List<Condition> conditions;
  final List<Attribute> attributes;
  final Attribute? attribute;
  final Comparison comparison;
  final String value;
  final bool enabled;
  final void Function(List<Condition>) onSaved;

  @override
  Widget build(BuildContext context) {
    final id = conditions[index].id;
    return Row(
      children: [
        Flexible(
          child: TSelectedVanilla(
            key: ValueKey(id),
            initialValue: attribute?.name,
            enabled: enabled,
            onTapped: () async => showMaterialModalBottomSheet<Attribute?>(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (bContext) => AttributeSheet(
                // when select attribute, return attribute
                onAttributeSeleted: (attribute) =>
                    Navigator.of(bContext).pop(attribute),
                attributes: attributes,
                selectedAttributeID: attribute?.id,
              ),
            ).then((attribute) {
              if (attribute != null) {
                if (index >= 0 && index < conditions.length) {
                  final cd = conditions[index];
                  final updatedCd = cd.copyWith(attributeID: attribute.id);
                  conditions[index] = updatedCd;
                  onSaved(conditions);
                }
                return attribute.name;
              }
              return null;
            }),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Device must not be empty';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 4),
        TComparisonItem(
          key: ValueKey(id),
          comparison: comparison,
          enabled: enabled,
          onPressed: () async => showMaterialModalBottomSheet<Comparison?>(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (bContext) => ComparisonSheet(
              // when select comparison, return comparison
              onComparisonSelected: (comparison) =>
                  Navigator.of(bContext).pop(comparison),
            ),
          ).then((comparison) {
            if (comparison != null) {
              if (index >= 0 && index < conditions.length) {
                final cd = conditions[index];
                final updatedCd = cd.copyWith(comparison: comparison);
                conditions[index] = updatedCd;
                onSaved(conditions);
              }
            }
            return null;
          }),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: TVanillaText(
            key: ValueKey(id),
            initText: value,
            hintText: 'Value',
            enabled: enabled,
            onChanged: (newValue) {
              if (index >= 0 && index < conditions.length) {
                final cd = conditions[index];
                final updatedCd = cd.copyWith(value: newValue);
                conditions[index] = updatedCd;
                onSaved(conditions);
              }
            },
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  double.tryParse(value) == null) {
                return 'Invalid';
              }
              return null;
            },
            textInputType: TextInputType.number,
          ),
        ),
        TCircleButton(
          picture: Assets.icons.trash
              .svg(color: ColorName.neural600, fit: BoxFit.scaleDown),
          onPressed: () {
            if (enabled) {
              if (index >= 0 && index < conditions.length) {
                conditions.removeAt(index);
                onSaved(conditions);
              }
            }
          },
        )
      ],
    );
  }
}
