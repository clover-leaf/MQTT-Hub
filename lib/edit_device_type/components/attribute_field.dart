import 'package:bee/components/component.dart';
import 'package:bee/edit_device_type/bloc/bloc.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class AttributeField extends StatefulWidget {
  const AttributeField({
    super.key,
    required this.initialAttributes,
    required this.deviceTypeID,
    required this.isEdit,
  });

  final List<Attribute> initialAttributes;
  final String deviceTypeID;
  final bool isEdit;

  @override
  State<AttributeField> createState() => _AttributeFieldState();
}

class _AttributeFieldState extends State<AttributeField> {
  late List<Attribute> _attributes;

  @override
  void initState() {
    _attributes = widget.initialAttributes;
    super.initState();
  }

  void updateBloc(BuildContext context, List<Attribute> attributes) {
    context.read<EditDeviceTypeBloc>().add(AttributesChanged(attributes));
  }

  /// lauch given url
  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // get text theme of context
    final textTheme = Theme.of(context).textTheme;

    return FormField(
      initialValue: _attributes,
      validator: (_) {
        if (_attributes.isEmpty) {
          return 'Device must have at least one attribute';
        } else {
          final expressions = <String>[];
          for (final att in _attributes) {
            if (expressions.contains(att.jsonPath)) {
              return 'Each attribute must have different expression';
            } else {
              expressions.add(att.jsonPath);
            }
          }
        }
        return null;
      },
      builder: (attributeFormFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ATTRIBUTE LIST',
                style:
                    textTheme.bodySmall!.copyWith(color: ColorName.neural600),
              ),
              TAddButton(
                label: 'ADD ATTRIBUTE',
                enabled: widget.isEdit,
                onPressed: () {
                  final att = Attribute(
                    id: const Uuid().v4(),
                    deviceID: null,
                    deviceTypeID: widget.deviceTypeID,
                    name: '',
                    jsonPath: '',
                    unit: '',
                  );
                  final attributes = [..._attributes, att];
                  updateBloc(context, attributes);
                  setState(() {
                    _attributes = attributes;
                  });
                },
              )
            ],
          ),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                const TextSpan(
                  text: 'An syntax is used for extracting attribute '
                      'from the payload using JSON Pointer (RFC 6091). Visit',
                ),
                WidgetSpan(
                  baseline: TextBaseline.alphabetic,
                  alignment: PlaceholderAlignment.baseline,
                  child: InkWell(
                    onTap: () =>
                        _launchUrl('https://www.rfc-editor.org/rfc/rfc6901'),
                    child: Text(
                      ' this link ',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .merge(const TextStyle(color: ColorName.sky500)),
                    ),
                  ),
                ),
                const TextSpan(
                  text: 'for in-depth instructions.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(_attributes.length, (index) {
            final att = _attributes[index];
            final name = att.name;
            final expression = att.jsonPath;
            final unit = att.unit;
            return Column(
              children: [
                _AttributeItem(
                  index: index,
                  name: name,
                  expression: expression,
                  unit: unit,
                  attributes: _attributes,
                  isEdit: widget.isEdit,
                  onSaved: (attributes) {
                    updateBloc(context, attributes);
                    setState(() {
                      _attributes = attributes;
                    });
                  },
                ),
                const SizedBox(height: 12)
              ],
            );
          }),
          // List ranges error line
          if (attributeFormFieldState.hasError)
            Text(
              attributeFormFieldState.errorText!,
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

class _AttributeItem extends StatelessWidget {
  const _AttributeItem({
    required this.index,
    required this.attributes,
    required this.name,
    required this.expression,
    required this.unit,
    required this.onSaved,
    required this.isEdit,
  });

  final int index;
  final List<Attribute> attributes;
  final String name;
  final String expression;
  final String? unit;
  final bool isEdit;
  final void Function(List<Attribute>) onSaved;

  @override
  Widget build(BuildContext context) {
    final id = attributes[index].id;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: TVanillaText(
            key: ValueKey(id),
            initText: name,
            hintText: 'Name',
            onChanged: (name) {
              if (index >= 0 && index < attributes.length) {
                final att = attributes[index];
                final updatedAtt = att.copyWith(name: name);
                attributes[index] = updatedAtt;
                onSaved(attributes);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Invalid';
              }
              return null;
            },
            enabled: isEdit,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          flex: 3,
          child: TVanillaText(
            key: ValueKey(id),
            initText: expression,
            hintText: 'Syntax',
            onChanged: (jsonPath) {
              if (index >= 0 && index < attributes.length) {
                final att = attributes[index];
                final updatedAtt = att.copyWith(jsonPath: jsonPath);
                attributes[index] = updatedAtt;
                onSaved(attributes);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Invalid';
              }
              return null;
            },
            enabled: isEdit,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          flex: 2,
          child: TVanillaText(
            key: ValueKey(id),
            initText: unit,
            hintText: 'Unit',
            onChanged: (unit) {
              if (index >= 0 && index < attributes.length) {
                final att = attributes[index];
                final updatedAtt = att.copyWith(unit: unit);
                attributes[index] = updatedAtt;
                onSaved(attributes);
              }
            },
            validator: (value) => null,
            enabled: isEdit,
          ),
        ),
        TCircleButton(
          picture: Assets.icons.trash
              .svg(color: ColorName.neural600, fit: BoxFit.scaleDown),
          onPressed: () {
            if (isEdit) {
              if (index >= 0 && index < attributes.length) {
                attributes.removeAt(index);
                onSaved(attributes);
              }
            }
          },
        )
      ],
    );
  }
}
