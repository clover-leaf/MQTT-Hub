part of 'brokers_overview_bloc.dart';

class BrokersOverviewEvent extends Equatable {
  const BrokersOverviewEvent();

  @override
  List<Object?> get props => [];
}

class BrokerSubscriptionRequested extends BrokersOverviewEvent {
  const BrokerSubscriptionRequested();
}
