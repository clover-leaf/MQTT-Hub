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
    required List<Attribute> initialAttributes,
    required List<Broker> brokers,
    required Device? initialDevice,
  }) : super(
          EditDeviceState(
            id: initialID,
            parentGroupID: parentGroupID,
            brokers: brokers,
            initialAttributes: initialAttributes,
            attributes: initialAttributes,
            initialDevice: initialDevice,
            name: initialDevice?.name ?? '',
            topic: initialDevice?.topic ?? '',
            selectedBrokerID: initialDevice?.brokerID,
          ),
        ) {
    on<Submitted>(_onSubmitted);
    on<NameChanged>(_onNameChanged);
    on<TopicChanged>(_onTopicChanged);
    on<SelectedBrokerIDChanged>(_onSelectedBrokerIDChanged);
    on<AttributesChanged>(_onAttributesChanged);
  }

  final UserRepository _userRepository;

  void _onNameChanged(NameChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onTopicChanged(TopicChanged event, Emitter<EditDeviceState> emit) {
    emit(state.copyWith(topic: event.topic));
  }

  void _onSelectedBrokerIDChanged(
    SelectedBrokerIDChanged event,
    Emitter<EditDeviceState> emit,
  ) {
    emit(state.copyWith(selectedBrokerID: event.selectedBrokerID));
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
      final device = state.initialDevice?.copyWith(
            brokerID: state.selectedBrokerID,
            name: state.name,
            topic: state.topic,
          ) ??
          Device(
            id: state.id,
            groupID: state.parentGroupID,
            brokerID: state.selectedBrokerID!,
            name: state.name,
            topic: state.topic,
          );
      await _userRepository.saveDevice(device);
      final initialAttributeIDs =
          state.initialAttributes.map((att) => att.id).toList();
      final initialAttributeView = {
        for (final att in state.initialAttributes) att.id: att
      };
      final attributesIDs = state.attributes.map((att) => att.id).toList();
      // handle new attribute
      final newAttributes = state.attributes
          .where((att) => !initialAttributeIDs.contains(att.id));
      for (final att in newAttributes) {
        await _userRepository.saveAttribute(att);
      }
      // handle editted attribute
      final edittedAttributes = state.attributes
          .where(
            (att) =>
                initialAttributeIDs.contains(att.id) &&
                att != initialAttributeView[att.id],
          )
          .toList();
      for (final att in edittedAttributes) {
        await _userRepository.saveAttribute(att);
      }
      // handle deleted attribute
      final deletedAttributes = state.initialAttributes
          .where((att) => !attributesIDs.contains(att.id))
          .toList();
      for (final att in deletedAttributes) {
        await _userRepository.deleteAttribute(att.id);
      }
      emit(state.copyWith(status: EditDeviceStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: EditDeviceStatus.failure, error: () => err));
      emit(state.copyWith(status: EditDeviceStatus.normal, error: () => null));
    }
  }
}
