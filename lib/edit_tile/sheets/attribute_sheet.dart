import 'package:bee/components/component.dart';
import 'package:bee/edit_tile/bloc/edit_tile_bloc.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class AttributeSheet extends StatelessWidget {
  const AttributeSheet({
    super.key,
    required this.onAttributeSeleted,
  });

  final void Function(Attribute) onAttributeSeleted;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTileBloc, EditTileState>(
      builder: (context, state) {
        final textTheme = Theme.of(context).textTheme;
        final showedAttributes = state.showedAttributes;
        final selectedAttributeID = state.selectedAttributeID;

        return Container(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 28),
                child: Text(
                  'ATTRIBUTES',
                  style: textTheme.titleSmall,
                ),
              ),
              if (showedAttributes.isEmpty)
                Container(
                  alignment: Alignment.center,
                  height: 96,
                  child: Text(
                    'There is no attribute in this device',
                    style: textTheme.titleSmall,
                  ),
                )
              else
                ...showedAttributes.map(
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
      },
    );
  }
}
