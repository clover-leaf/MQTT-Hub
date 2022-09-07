import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_device_event.dart';
part 'edit_device_state.dart';

class EditDeviceBloc extends Bloc<EditDeviceEvent, EditDeviceState> {
  EditDeviceBloc(
    this._userRepository, {
    required String initialID,
    required String parentGroupID,
    required List<Attribute> allAttributes,
    required List<Attribute> initialAttributes,
    required List<Broker> brokers,
    required List<DeviceType> deviceTypes,
    required Device? initialDevice,
    required bool isUseDeviceType,
    required bool isAdmin,
    required bool isEdit,
  }) : super(
          EditDeviceState(
            isEdit: isEdit,
            isAdmin: isAdmin,
            id: initialID,
            parentGroupID: parentGroupID,
            brokers: brokers,
            deviceTypes: deviceTypes,
            allAttributes: allAttributes,
            initialAttributes: initialAttributes,
            attributes: initialAttributes,
            initialDevice: initialDevice,
            name: initialDevice?.name ?? '',
            topic: initialDevice?.topic ?? '',
            isUseDeviceType: isUseDeviceType,
            selectedBrokerID: initialDevice?.brokerID,
          ),
        ) {
    on<Submitted>(_onSubmitted);
    on<IsEditChanged>(_onIsEditChanged);
    on<NameChanged>(_onNameChanged);
    on<TopicChanged>(_onTopicChanged);
    on<QosChanged>(_onQosChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<SelectedBrokerIDChanged>(_onSelectedBrokerIDChanged);
    on<SelectedDeviceTypeIDChanged>(_onSelectedDeviceTypeIDChanged);
    on<AttributesChanged>(_onAttributesChanged);
  }

  final UserRepository _userRepository;

  void _onIsEditChanged(IsEditChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(isEdit: event.isEdit));
  }

  void _onNameChanged(NameChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onTopicChanged(TopicChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(topic: event.topic));
  }

  void _onQosChanged(QosChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(qos: event.qos));
  }

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onSelectedBrokerIDChanged(
    SelectedBrokerIDChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(state.copyWith(selectedBrokerID: event.selectedBrokerID));
  }

  void _onSelectedDeviceTypeIDChanged(
    SelectedDeviceTypeIDChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(
      state.copyWith(selectedDeviceTypeID: event.selectedDeviceTypeID),
    );
  }

  void _onAttributesChanged(
    AttributesChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(state.copyWith(attributes: event.attributes));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<EditDeviceState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditDeviceStatus.processing));
      final device = Device(
        id: state.id,
        groupID: state.parentGroupID,
        deviceTypeID: state.selectedDeviceTypeID,
        brokerID: state.selectedBrokerID!,
        name: state.name,
        description: state.description,
        topic: state.topic,
        qos: state.qos,
      );
      await _userRepository.saveDevice(device);
      final attributesIDs = state.attributes.map((att) => att.id).toList();
      // handle deleted attribute
      final deletedAttributes = state.initialAttributes
          .where((att) => !attributesIDs.contains(att.id))
          .toList();
      for (final att in deletedAttributes) {
        await _userRepository.deleteAttribute(att.id);
      }
      if (state.selectedDeviceTypeID == null) {
        final initialAttributeIDs =
            state.initialAttributes.map((att) => att.id).toList();
        // handle new attribute
        final newAttributes = state.attributes
            .where((att) => !initialAttributeIDs.contains(att.id))
            .toList();
        for (final att in newAttributes) {
          await _userRepository.saveAttribute(att);
        }
        // handle editted attribute
        final edittedAttributes = state.attributes
            .where((att) => initialAttributeIDs.contains(att.id))
            .toList();
        for (final att in edittedAttributes) {
          await _userRepository.saveAttribute(att);
        }
      }
      emit(state.copyWith(status: EditDeviceStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: EditDeviceStatus.failure, error: () => err));
      emit(state.copyWith(status: EditDeviceStatus.normal, error: () => null));
    }
  }
}
