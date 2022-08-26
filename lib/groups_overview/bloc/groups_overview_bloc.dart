import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'groups_overview_event.dart';
part 'groups_overview_state.dart';

class GroupsOverviewBloc
    extends Bloc<GroupsOverviewEvent, GroupsOverviewState> {
  GroupsOverviewBloc(
    this._userRepository, {
    required Project parentProject,
    required bool isAdmin,
  }) : super(
          GroupsOverviewState(
            parentProject: parentProject,
            isAdmin: isAdmin,
          ),
        ) {
    on<GroupSubscriptionRequested>(_onGroupSubscribed);
    on<DeviceSubscriptionRequested>(_onDeviceSubscribed);
  }

  final UserRepository _userRepository;

  Future<void> _onGroupSubscribed(
    GroupSubscriptionRequested event,
    Emitter<GroupsOverviewState> emit,
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
    Emitter<GroupsOverviewState> emit,
  ) async {
    await emit.forEach<List<Device>>(
      _userRepository.subscribeDeviceStream(),
      onData: (devices) {
        return state.copyWith(devices: devices);
      },
    );
  }
}
