import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_device_event.dart';
part 'edit_device_state.dart';

class EditDeviceBloc extends Bloc<EditDeviceEvent, EditDeviceState> {
  EditDeviceBloc(
    this._userRepository, {
    required Group parentGroup,
    required Device? initDevice,
  }) : super(
          EditDeviceState(
            parentGroup: parentGroup,
            initDevice: initDevice,
          ),
        ) {
    on<EditSubmitted>(_onSubmitted);
    on<EditDeviceNameChanged>(_onDeviceNameChanged);
  }

  final UserRepository _userRepository;

  void _onDeviceNameChanged(
    EditDeviceNameChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    final deviceName = DeviceName.dirty(event.deviceName);
    emit(
      state.copyWith(
        deviceName: deviceName,
        valid: Formz.validate([deviceName]).isValid,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditSubmitted event,
    Emitter<EditDeviceState> emit,
  ) async {
    try {
      if (state.status.isSubmissionInProgress || !state.valid) {
        emit(state.copyWith(error: 'Please fill infomation'));
        return;
      }
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      final device = state.initDevice?.copyWith(name: event.deviceName) ??
          Device(
            groupID: state.parentGroup.id,
            name: event.deviceName,
          );
      await _userRepository.saveDevice(device);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (error) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          error: error.toString(),
        ),
      );
    }
  }
}
