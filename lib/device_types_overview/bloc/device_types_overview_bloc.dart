import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'device_types_overview_event.dart';
part 'device_types_overview_state.dart';

class DeviceTypesOverviewBloc
    extends Bloc<DeviceTypesOverviewEvent, DeviceTypesOverviewState> {
  DeviceTypesOverviewBloc(
    this._userRepository, {
    required Project parentProject,
    required bool isAdmin,
  }) : super(
          DeviceTypesOverviewState(
            parentProject: parentProject,
            isAdmin: isAdmin,
          ),
        ) {
    on<DeviceTypeSubscriptionRequested>(_onDeviceTypeSubscribed);
    on<AttributeSubscriptionRequested>(_onAttributeSubscribed);
    on<DeletionRequested>(_onDeleted);
  }

  final UserRepository _userRepository;

  Future<void> _onDeleted(
    DeletionRequested event,
    Emitter<DeviceTypesOverviewState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DeviceTypesOverviewStatus.processing));
      await _userRepository.deleteDeviceType(event.deviceTypeID);
      emit(state.copyWith(status: DeviceTypesOverviewStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(
        state.copyWith(
          status: DeviceTypesOverviewStatus.failure,
          error: () => err,
        ),
      );
      emit(
        state.copyWith(
          status: DeviceTypesOverviewStatus.normal,
          error: () => null,
        ),
      );
    }
  }

  Future<void> _onDeviceTypeSubscribed(
    DeviceTypeSubscriptionRequested event,
    Emitter<DeviceTypesOverviewState> emit,
  ) async {
    await emit.forEach<List<DeviceType>>(
      _userRepository.subscribeDeviceTypeStream(),
      onData: (deviceTypes) {
        return state.copyWith(deviceTypes: deviceTypes);
      },
    );
  }

  Future<void> _onAttributeSubscribed(
    AttributeSubscriptionRequested event,
    Emitter<DeviceTypesOverviewState> emit,
  ) async {
    await emit.forEach<List<Attribute>>(
      _userRepository.subscribeAttributeStream(),
      onData: (attributes) {
        return state.copyWith(attributes: attributes);
      },
    );
  }
}
