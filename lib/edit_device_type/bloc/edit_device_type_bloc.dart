import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_device_type_event.dart';
part 'edit_device_type_state.dart';

class EditDeviceTypeBloc
    extends Bloc<EditDeviceTypeEvent, EditDeviceTypeState> {
  EditDeviceTypeBloc(
    this._userRepository, {
    required String initialID,
    required String parentProjectID,
    required List<Attribute> initialAttributes,
    required DeviceType? initialDeviceType,
    required bool isAdmin,
    required bool isEdit,
  }) : super(
          EditDeviceTypeState(
            isEdit: isEdit,
            isAdmin: isAdmin,
            id: initialID,
            parentProjectID: parentProjectID,
            initialAttributes: initialAttributes,
            attributes: initialAttributes,
            initialDeviceType: initialDeviceType,
            name: initialDeviceType?.name ?? '',
            description: initialDeviceType?.description ?? '',
          ),
        ) {
    on<Submitted>(_onSubmitted);
    on<IsEditChanged>(_onIsEditChanged);
    on<NameChanged>(_onNameChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<AttributesChanged>(_onAttributesChanged);
  }

  final UserRepository _userRepository;

  void _onIsEditChanged(
    IsEditChanged event,
    Emitter<EditDeviceTypeState> emit,
  ) {
    emit(state.copyWith(isEdit: event.isEdit));
  }

  void _onNameChanged(NameChanged event, Emitter<EditDeviceTypeState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<EditDeviceTypeState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onAttributesChanged(
    AttributesChanged event,
    Emitter<EditDeviceTypeState> emit,
  ) {
    emit(state.copyWith(attributes: event.attributes));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<EditDeviceTypeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditDeviceTypeStatus.processing));
      final deviceType = state.initialDeviceType?.copyWith(
            name: state.name,
            description: state.description,
          ) ??
          DeviceType(
            id: state.id,
            projectID: state.parentProjectID,
            name: state.name,
            description: state.description,
          );
      await _userRepository.saveDeviceType(deviceType);
      final initialAttributeIDs =
          state.initialAttributes.map((att) => att.id).toList();
      final attributesIDs = state.attributes.map((att) => att.id).toList();
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
      // handle deleted attribute
      final deletedAttributes = state.initialAttributes
          .where((att) => !attributesIDs.contains(att.id))
          .toList();
      for (final att in deletedAttributes) {
        await _userRepository.deleteAttribute(att.id);
      }
      emit(state.copyWith(status: EditDeviceTypeStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(
        state.copyWith(
          status: EditDeviceTypeStatus.failure,
          error: () => err,
        ),
      );
      emit(
        state.copyWith(
          status: EditDeviceTypeStatus.normal,
          error: () => null,
        ),
      );
    }
  }
}
