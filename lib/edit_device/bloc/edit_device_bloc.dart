import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

part 'edit_device_event.dart';
part 'edit_device_state.dart';

class EditDeviceBloc extends Bloc<EditDeviceEvent, EditDeviceState> {
  EditDeviceBloc(
    this._userRepository, {
    required String path,
    required Project rootProject,
    required Group parentGroup,
    required List<Attribute> initAttributes,
    required Device? initDevice,
  }) : super(
          EditDeviceState(
            id: initDevice?.id ?? const Uuid().v4(),
            path: path,
            rootProject: rootProject,
            parentGroup: parentGroup,
            initAttributes: initAttributes,
            selectedAttributes: initAttributes,
            initDevice: initDevice,
            deviceName: initDevice != null
                ? DeviceName.dirty(initDevice.name)
                : const DeviceName.pure(),
            topicName: initDevice != null
                ? TopicName.dirty(initDevice.topic)
                : const TopicName.pure(),
            selectedBrokerID: initDevice?.brokerID,
          ),
        ) {
    on<EditSubmitted>(_onSubmitted);
    on<EditDeviceNameChanged>(_onDeviceNameChanged);
    on<EditTopicNameChanged>(_onTopicNameChanged);
    on<EditSelectedBrokerIDChanged>(_onSelectedBrokerIDChanged);
    on<EditTempAttributeNameChanged>(_onTempAttributeNameChanged);
    on<EditTempAttributeJsonPathChanged>(_onTempAttributeJsonPathChanged);
    on<EditTempAttributeSaved>(_onTempAttributeSaved);
    on<BrokerSubscriptionRequested>(_onBrokerSubscriptionRequested);
  }

  final UserRepository _userRepository;

  Future<void> _onBrokerSubscriptionRequested(
    BrokerSubscriptionRequested event,
    Emitter<EditDeviceState> emit,
  ) async {
    await emit.forEach<List<Broker>>(
      _userRepository.subscribeBrokerStream(),
      onData: (brokers) {
        return state.copyWith(brokers: brokers);
      },
    );
  }

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

  void _onTopicNameChanged(
    EditTopicNameChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    final topicName = TopicName.dirty(event.topicName);
    emit(
      state.copyWith(
        topicName: topicName,
        valid: Formz.validate([topicName]).isValid,
      ),
    );
  }

  void _onSelectedBrokerIDChanged(
    EditSelectedBrokerIDChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(state.copyWith(selectedBrokerID: event.selectedBrokerID));
  }

  void _onTempAttributeNameChanged(
    EditTempAttributeNameChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(state.copyWith(tempAttributeName: event.tempAttributeName));
  }

  void _onTempAttributeJsonPathChanged(
    EditTempAttributeJsonPathChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(state.copyWith(tempAttributeJsonPath: event.tempAttributeJsonPath));
  }

  Future<void> _onTempAttributeSaved(
    EditTempAttributeSaved event,
    Emitter<EditDeviceState> emit,
  ) async {
    try {
      final attributeName = state.tempAttributeName;
      final attributeJsonPath = state.tempAttributeJsonPath;
      final attribute = Attribute(
        deviceID: state.id,
        name: attributeName,
        jsonPath: attributeJsonPath,
      );
      emit(
        state.copyWith(
          selectedAttributes: [...state.selectedAttributes, attribute],
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          error: err.toString(),
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    EditSubmitted event,
    Emitter<EditDeviceState> emit,
  ) async {
    try {
      if (state.status.isSubmissionInProgress ||
          !state.valid ||
          event.selectedBrokerID == null) {
        emit(state.copyWith(error: 'Please fill all infomation'));
        return;
      }
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      final device = state.initDevice?.copyWith(
            brokerID: event.selectedBrokerID,
            name: event.deviceName,
            topic: event.topicName,
          ) ??
          Device(
            id: state.id,
            groupID: state.parentGroup.id,
            brokerID: event.selectedBrokerID!,
            name: event.deviceName,
            topic: event.topicName,
          );
      await _userRepository.saveDevice(device);
      for (final attr in state.selectedAttributes) {
        await _userRepository.saveAttribute(attr);
      }
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
