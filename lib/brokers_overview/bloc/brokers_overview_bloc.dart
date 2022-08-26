import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'brokers_overview_event.dart';
part 'brokers_overview_state.dart';

class BrokersOverviewBloc
    extends Bloc<BrokersOverviewEvent, BrokersOverviewState> {
  BrokersOverviewBloc(
    this._userRepository, {
    required Project parentProject,
    required bool isAdmin,
  }) : super(
          BrokersOverviewState(
            parentProject: parentProject,
            isAdmin: isAdmin,
          ),
        ) {
    on<BrokerSubscriptionRequested>(_onBrokerSubscribed);
    on<DeletionRequested>(_onDeleted);
  }

  final UserRepository _userRepository;

  Future<void> _onDeleted(
    DeletionRequested event,
    Emitter<BrokersOverviewState> emit,
  ) async {
    try {
      emit(state.copyWith(status: BrokersOverviewStatus.processing));
      await _userRepository.deleteBroker(event.brokerID);
      emit(state.copyWith(status: BrokersOverviewStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(
        state.copyWith(status: BrokersOverviewStatus.failure, error: () => err),
      );
      emit(
        state.copyWith(status: BrokersOverviewStatus.normal, error: () => null),
      );
    }
  }

  Future<void> _onBrokerSubscribed(
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
