import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'group_detail_event.dart';
part 'group_detail_state.dart';

class GroupDetailBloc extends Bloc<GroupDetailEvent, GroupDetailState> {
  GroupDetailBloc(
    this._userRepository, {
    required Group group,
    required Project? parentProject,
    required Group? parentGroup,
  }) : super(
          GroupDetailState(
            group: group,
            parentProject: parentProject,
            parentGroup: parentGroup,
          ),
        ) {
    on<GroupSubscriptionRequested>(_onGroupSubscriptionRequested);
    on<DeviceSubscriptionRequested>(_onDeviceSubscriptionRequested);
  }

  final UserRepository _userRepository;

  /// Subcribes [Stream] of [List] of [Group]
  Future<void> _onGroupSubscriptionRequested(
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

  /// Subcribes [Stream] of [List] of [Device]
  Future<void> _onDeviceSubscriptionRequested(
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
