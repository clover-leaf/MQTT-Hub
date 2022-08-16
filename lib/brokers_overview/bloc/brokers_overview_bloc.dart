import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'brokers_overview_event.dart';
part 'brokers_overview_state.dart';

class BrokersOverviewBloc
    extends Bloc<BrokersOverviewEvent, BrokersOverviewState> {
  BrokersOverviewBloc(this._userRepository, {required Project parentProject})
      : super(BrokersOverviewState(parentProject: parentProject)) {
    on<BrokerSubscriptionRequested>(_onBrokerSubscriptionRequested);
  }

  final UserRepository _userRepository;

  Future<void> _onBrokerSubscriptionRequested(
    BrokerSubscriptionRequested event,
    Emitter<BrokersOverviewState> emit,
  ) async {
    await emit.forEach<List<Broker>>(
      _userRepository.subscribeBrokerStream(),
      onData: (brokers) {
        return state.copyWith(brokers: brokers);
      },
    );
  }
}
