import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'group_detail_event.dart';
part 'group_detail_state.dart';

class GroupDetailBloc extends Bloc<GroupDetailEvent, GroupDetailState> {
  GroupDetailBloc(
    this._userRepository, {
    required Project rootProject,
    required Group group,
    required bool isAdmin,
  }) : super(
          GroupDetailState(
            isAdmin: isAdmin,
            rootProject: rootProject,
            group: group,
          ),
        ) {
    on<BrokerSubscriptionRequested>(_onBrokerSubscribed);
    on<GroupSubscriptionRequested>(_onGroupSubscribed);
    on<DeviceSubscriptionRequested>(_onDeviceSubscribed);
    on<DeletionRequested>(_onDeleted);
    on<GroupVisibilityChanged>(_onGroupVisibleChanged);
    on<DeviceVisibilityChanged>(_onDeviceVisibleChanged);
  }

  final UserRepository _userRepository;

  void _onGroupVisibleChanged(
    GroupVisibilityChanged event,
    Emitter<GroupDetailState> emit,
  ) {
    emit(state.copyWith(isShowGroup: event.isVisible));
  }

  void _onDeviceVisibleChanged(
    DeviceVisibilityChanged event,
    Emitter<GroupDetailState> emit,
  ) {
    emit(state.copyWith(isShowDevice: event.isVisible));
  }

  Future<void> _onDeleted(
    DeletionRequested event,
    Emitter<GroupDetailState> emit,
  ) async {
    try {
      emit(state.copyWith(status: GroupDetailStatus.processing));
      await _userRepository.deleteGroup(state.group.id);
      emit(state.copyWith(status: GroupDetailStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: GroupDetailStatus.failure, error: () => err));
      emit(state.copyWith(status: GroupDetailStatus.normal, error: () => null));
    }
  }

  Future<void> _onBrokerSubscribed(
    BrokerSubscriptionRequested event,
    Emitter<GroupDetailState> emit,
  ) async {
    await emit.forEach<List<Broker>>(
      _userRepository.subscribeBrokerStream(),
      onData: (brokers) {
        final brokerInProjects = brokers
            .where((br) => br.projectID == state.rootProject.id)
            .toList();
        return state.copyWith(brokers: brokerInProjects);
      },
    );
  }

  Future<void> _onGroupSubscribed(
    GroupSubscriptionRequested event,
    Emitter<GroupDetailState> emit,
  ) async {
    await emit.forEach<List<Group>>(
      _userRepository.subscribeGroupStream(),
      onData: (groups) {
        return state.copyWith(groups: groups);
      },
    );
  }

  Future<void> _onDeviceSubscribed(
    DeviceSubscriptionRequested event,
    Emitter<GroupDetailState> emit,
  ) async {
    await emit.forEach<List<Device>>(
      _userRepository.subscribeDeviceStream(),
      onData: (devices) {
        return state.copyWith(devices: devices);
      },
    );
  }
}
