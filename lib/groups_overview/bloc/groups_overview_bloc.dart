import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'groups_overview_event.dart';
part 'groups_overview_state.dart';

class GroupsOverviewBloc
    extends Bloc<GroupsOverviewEvent, GroupsOverviewState> {
  GroupsOverviewBloc(this._userRepository, {required Project project})
      : super(GroupsOverviewState(project: project)) {
    on<GroupSubscriptionRequested>(_onGroupSubscriptionRequested);
  }

  final UserRepository _userRepository;

  Future<void> _onGroupSubscriptionRequested(
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
}
