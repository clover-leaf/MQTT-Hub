import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'device_detail_event.dart';
part 'device_detail_state.dart';

class DeviceDetailBloc extends Bloc<DeviceDetailEvent, DeviceDetailState> {
  DeviceDetailBloc(
    this._userRepository, {
    required String path,
    required Device device,
  }) : super(DeviceDetailState(path: path, device: device)) {
    on<AttributeSubscriptionRequested>(_onAttributeSubscriptionRequested);
  }

  final UserRepository _userRepository;

  Future<void> _onAttributeSubscriptionRequested(
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
}
