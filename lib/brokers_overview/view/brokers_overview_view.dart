import 'package:bee/brokers_overview/brokers_overview.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class BrokersOverviewView extends StatelessWidget {
  const BrokersOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final showedBrokers =
        context.select((BrokersOverviewBloc bloc) => bloc.state.showedBrokers);

    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 32,
      ),
      children: [
        const _Header(),
        ...showedBrokers.map(_BrokerItem.new).toList()
      ],
    );
  }
}

class _BrokerItem extends StatelessWidget {
  const _BrokerItem(this.broker);

  final Broker broker;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.white,
        onPrimary: ColorName.blue,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: () => {},
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              broker.name,
              style: textTheme.titleMedium,
            ),
            Assets.icons.more.svg()
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final parentProject =
        context.select((BrokersOverviewBloc bloc) => bloc.state.parentProject);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            parentProject.name,
            style: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Brokers',
            style: textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
