import 'dart:convert';

import 'package:bee/components/t_add_button.dart';
import 'package:bee/components/t_circle_button.dart';
import 'package:bee/components/t_vanilla_text.dart';
import 'package:bee/edit_tile/bloc/bloc.dart';
import 'package:bee/edit_tile/data/data.dart';
import 'package:bee/edit_tile/sheets/color_sheet.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class GaugeTileField extends StatefulWidget {
  const GaugeTileField(this.initialLob, {super.key});

  final String initialLob;

  @override
  State<GaugeTileField> createState() => _GaugeTileFieldState();
}

class _GaugeTileFieldState extends State<GaugeTileField> {
  late List<GaugeRange> _gaugeRanges;
  late List<String> _ggRIdentities;

  @override
  void initState() {
    // decode lob
    // we will get {'ranges':[{'min':0,'max':100,'color':'#123456'}]}
    final decoded = jsonDecode(widget.initialLob) as Map<String, dynamic>;
    // get ranges
    final ranges = decoded['ranges']! as List<dynamic>;
    // convert ranges to list of GaugeRange
    _gaugeRanges = ranges
        .map((json) => GaugeRange.fromJson(json as Map<String, dynamic>))
        .toList();
    _ggRIdentities =
        List.generate(_gaugeRanges.length, (_) => const Uuid().v4());
    super.initState();
  }

  void updateBloc(BuildContext context, List<GaugeRange> gaugeRanges) {
    // convert GaugeRange list to json list
    final jsonGaugeRanges = gaugeRanges.map((ggR) => ggR.toJson()).toList();
    // create new lob
    final lob = jsonEncode({'ranges': jsonGaugeRanges});
    context.read<EditTileBloc>().add(LobChanged(lob));
  }

  @override
  Widget build(BuildContext context) {
    // get text theme of context
    final textTheme = Theme.of(context).textTheme;

    return FormField(
      initialValue: _gaugeRanges,
      validator: (_) {
        if (_gaugeRanges.isEmpty) {
          return 'Must have at least one range';
        }
        if (_gaugeRanges.length < 2) {
          return null;
        } else {
          for (var idx = 0; idx < _gaugeRanges.length - 1; idx++) {
            final curRange = _gaugeRanges[idx];
            final nxtRange = _gaugeRanges[idx + 1];
            if (curRange.min == null ||
                curRange.max == null ||
                nxtRange.min == null ||
                nxtRange.max == null) {
              return null;
            }
            if (curRange.max!.compareTo(nxtRange.min!) != 0) {
              return 'Ranges must be consecutive';
            }
          }
        }
        return null;
      },
      builder: (rangesFormFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RANGES LIST',
                style:
                    textTheme.bodySmall!.copyWith(color: ColorName.neural600),
              ),
              TAddButton(
                label: 'ADD RANGE',
                onPressed: () {
                  final gaugeRange = GaugeRange(
                    color: TileHelper.colorToString(ColorName.iColor1),
                  );
                  final gaugeRanges = [..._gaugeRanges, gaugeRange];
                  final ggRIdentities = [..._ggRIdentities, const Uuid().v4()];
                  setState(() {
                    _ggRIdentities = ggRIdentities;
                  });
                  updateBloc(context, gaugeRanges);
                  setState(() {
                    _gaugeRanges = gaugeRanges;
                  });
                },
              )
            ],
          ),
          const SizedBox(height: 8),
          ...List.generate(_gaugeRanges.length, (index) {
            final ggR = _gaugeRanges[index];
            return FormField(
              initialValue: ggR,
              validator: (_) {
                // ignore min, max is not double
                if (ggR.min == null ||
                    ggR.min!.isEmpty ||
                    double.tryParse(ggR.min!) == null ||
                    ggR.max == null ||
                    ggR.max!.isEmpty ||
                    double.tryParse(ggR.max!) == null) {
                  return null;
                }
                final min = double.parse(ggR.min!);
                final max = double.parse(ggR.max!);
                if (min >= max) {
                  return 'Max must be greater than min';
                }
                return null;
              },
              builder: (rangeFormFieldState) {
                final min = ggR.min ?? '';
                final max = ggR.max ?? '';
                final color = TileHelper.stringToColor(ggR.color);
                return Column(
                  children: [
                    _GaugeRangeItem(
                      index: index,
                      gaugeRanges: _gaugeRanges,
                      ggRIdentities: _ggRIdentities,
                      min: min,
                      max: max,
                      onSaved: (gaugeRanges) {
                        updateBloc(context, gaugeRanges);
                        setState(() {
                          _gaugeRanges = gaugeRanges;
                        });
                      },
                      onDeleted: (ggRIdentities) {
                        setState(() {
                          _ggRIdentities = ggRIdentities;
                        });
                      },
                      color: color,
                    ),
                    // Range error line
                    if (rangeFormFieldState.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          rangeFormFieldState.errorText!,
                          style: textTheme.labelMedium!.copyWith(
                            color: ColorName.wine300,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12)
                  ],
                );
              },
            );
          }),
          // List ranges error line
          if (rangesFormFieldState.hasError)
            Text(
              rangesFormFieldState.errorText!,
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

class _GaugeRangeItem extends StatelessWidget {
  const _GaugeRangeItem({
    required this.index,
    required this.gaugeRanges,
    required this.ggRIdentities,
    required this.color,
    required this.min,
    required this.max,
    required this.onSaved,
    required this.onDeleted,
  });

  final int index;
  final List<GaugeRange> gaugeRanges;
  final List<String> ggRIdentities;
  final Color color;
  final String min;
  final String max;
  final void Function(List<GaugeRange>) onSaved;
  final void Function(List<String>) onDeleted;

  @override
  Widget build(BuildContext context) {
    final gaugeRange = gaugeRanges[index];
    final ggRIdentity = ggRIdentities[index];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async => showMaterialModalBottomSheet<Color?>(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (bContext) => ColorSheet(
              initialColor: color,
              onColorChanged: (color) => Navigator.of(bContext).pop(color),
            ),
          ).then((color) {
            if (color != null) {
              // convert selected color to String
              final colorInString = TileHelper.colorToString(color);
              // create new GaugeRange with coverted color
              final updatedGaugeRange =
                  gaugeRange.copyWith(color: colorInString);
              // update GaugeRange list
              gaugeRanges[index] = updatedGaugeRange;
              onSaved(gaugeRanges);
            }
          }),
          child: CircleAvatar(radius: 24, backgroundColor: color),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: TVanillaText(
            key: ValueKey(ggRIdentity),
            initText: min,
            hintText: 'Min Value',
            onChanged: (minInString) {
              // create new GaugeRange
              final updatedGaugeRange = gaugeRange.copyWith(min: minInString);
              // update GaugeRange list
              gaugeRanges[index] = updatedGaugeRange;
              onSaved(gaugeRanges);
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
        const SizedBox(width: 12),
        Flexible(
          child: TVanillaText(
            key: ValueKey(ggRIdentity),
            initText: max,
            hintText: 'Max Value',
            onChanged: (maxInString) {
              // create new GaugeRange
              final updatedGaugeRange = gaugeRange.copyWith(max: maxInString);
              // update GaugeRange list
              gaugeRanges[index] = updatedGaugeRange;
              onSaved(gaugeRanges);
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
            if (index >= 0 && index < gaugeRanges.length) {
              // remove at index
              ggRIdentities.removeAt(index);
              onDeleted(ggRIdentities);
              gaugeRanges.removeAt(index);
              onSaved(gaugeRanges);
            }
          },
        )
      ],
    );
  }
}
