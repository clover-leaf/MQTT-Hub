import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'device_detail_event.dart';
part 'device_detail_state.dart';

class DeviceDetailBloc extends Bloc<DeviceDetailEvent, DeviceDetailState> {
  DeviceDetailBloc(
    this._userRepository, {
    required Project rootProject,
    required Device device,
    required bool isAdmin,
  }) : super(
          DeviceDetailState(
            device: device,
            rootProject: rootProject,
            isAdmin: isAdmin,
          ),
        ) {
    on<AttributeSubscriptionRequested>(_onAttributeSubscribed);
    on<BrokerSubscriptionRequested>(_onBrokerSubscribed);
    on<DeviceSubscriptionRequested>(_onDeviceSubscribed);
    on<DeletionRequested>(_onDeleted);
  }

  final UserRepository _userRepository;

  Future<void> _onDeleted(
    DeletionRequested event,
    Emitter<DeviceDetailState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DeviceDetailStatus.processing));
      await _userRepository.deleteDevice(state.device.id);
      emit(state.copyWith(status: DeviceDetailStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(
        state.copyWith(status: DeviceDetailStatus.failure, error: () => err),
      );
      emit(
        state.copyWith(status: DeviceDetailStatus.normal, error: () => null),
      );
    }
  }

  Future<void> _onAttributeSubscribed(
    AttributeSubscriptionRequested event,
    Emitter<DeviceDetailState> emit,
  ) async {
    await emit.forEach<List<Attribute>>(
      _userRepository.subscribeAttributeStream(),
      onData: (attributes) {
        return state.copyWith(attributes: attributes);
      },
    );
  }

  Future<void> _onBrokerSubscribed(
    BrokerSubscriptionRequested event,
    Emitter<DeviceDetailState> emit,
  ) async {
    await emit.forEach<List<Broker>>(
      _userRepository.subscribeBrokerStream(),
      onData: (brokers) {
        return state.copyWith(brokers: brokers);
      },
    );
  }

  Future<void> _onDeviceSubscribed(
    DeviceSubscriptionRequested event,
    Emitter<DeviceDetailState> emit,
  ) async {
    await emit.forEach<List<Device>>(
      _userRepository.subscribeDeviceStream(),
      onData: (devices) {
        final deviceView = {for (final dv in devices) dv.id: dv};
        final _device = deviceView[state.device.id];

        return state.copyWith(devices: devices, device: _device);
      },
    );
  }
}
