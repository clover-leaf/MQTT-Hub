import 'package:bee/components/component.dart';
import 'package:bee/edit_device/bloc/edit_device_bloc.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class BrokerSheet extends StatelessWidget {
  const BrokerSheet({
    super.key,
    required this.onBrokerSelected,
  });

  final void Function(Broker) onBrokerSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDeviceBloc, EditDeviceState>(
      builder: (context, state) {
        final textTheme = Theme.of(context).textTheme;

        final selectedBrokerID = state.selectedBrokerID;
        final brokers = state.brokers;

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
              if (brokers.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  alignment: Alignment.center,
                  height: 96,
                  child: Text(
                    'There is no broker in this project',
                    style: textTheme.titleSmall,
                  ),
                )
              else
                ...brokers.map(
                  (br) => TBrokerItem(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    title: br.name,
                    subtitle: '${br.url}:${br.port}',
                    isSelected: br.id == selectedBrokerID,
                    onPressed: () => onBrokerSelected(br),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
