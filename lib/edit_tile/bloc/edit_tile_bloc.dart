import 'package:bee/edit_tile/data/data.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_tile_event.dart';
part 'edit_tile_state.dart';

class EditTileBloc extends Bloc<EditTileEvent, EditTileState> {
  EditTileBloc(
    this._userRepository, {
    required FieldId dashboardID,
    required TileType type,
    required List<Device> devices,
    required List<Attribute> attributes,
    required Tile? initialTile,
    required bool isAdmin,
    required bool isEdit,
  }) : super(
          EditTileState(
            isEdit: isEdit,
            // immutate
            isAdmin: isAdmin,
            dashboardID: dashboardID,
            devices: devices,
            attributes: attributes,
            type: type,
            // input base on initial tile
            tileName: initialTile?.name ?? '',
            selectedDeviceID: initialTile?.deviceID,
            selectedAttributeID: initialTile?.attributeID,
            lob: initialTile?.lob ?? type.getInitialLob(),
            color: initialTile?.color ??
                TileHelper.colorToString(ColorName.iColor1),
            icon: initialTile?.icon ??
                TileHelper.svgPathToString(Assets.icons.icon.path),
            initialTile: initialTile,
          ),
        ) {
    on<Submitted>(_onSubmitted);
    on<IsEditChanged>(_onIsEditChanged);
    on<TileNameChanged>(_onTileNameChanged);
    on<DeviceIDChanged>(_onDeviceIDChanged);
    on<AttributeIDChanged>(_onAttributeIDChanged);
    on<LobChanged>(_onBlobChanged);
    on<ColorChanged>(_onColorChanged);
    on<IconChanged>(_onIconChanged);
  }

  final UserRepository _userRepository;

  void _onIsEditChanged(IsEditChanged event, Emitter<EditTileState> emit) {
    emit(state.copyWith(isEdit: event.isEdit));
  }

  void _onTileNameChanged(TileNameChanged event, Emitter<EditTileState> emit) {
    emit(state.copyWith(tileName: event.tileName));
  }

  void _onDeviceIDChanged(DeviceIDChanged event, Emitter<EditTileState> emit) {
    final attributesInDevices = state.attributes
        .where((att) => att.deviceID == event.deviceID)
        .toList();
    final selectedAttributeID =
        attributesInDevices.isNotEmpty ? attributesInDevices.first.id : null;
    emit(
      state.copyWith(
        selectedDeviceID: event.deviceID,
        selectedAttributeID: selectedAttributeID,
      ),
    );
  }

  void _onAttributeIDChanged(
    AttributeIDChanged event,
    Emitter<EditTileState> emit,
  ) {
    emit(state.copyWith(selectedAttributeID: event.attributeID));
  }

  void _onBlobChanged(LobChanged event, Emitter<EditTileState> emit) {
    emit(state.copyWith(lob: event.lob));
  }

  void _onColorChanged(ColorChanged event, Emitter<EditTileState> emit) {
    emit(state.copyWith(color: event.color));
  }

  void _onIconChanged(IconChanged event, Emitter<EditTileState> emit) {
    emit(state.copyWith(icon: event.icon));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<EditTileState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditTileStatus.processing));
      final tile = state.initialTile?.copyWith(
            deviceID: state.selectedDeviceID,
            attributeID: state.selectedAttributeID,
            name: state.tileName,
            lob: state.lob,
            color: state.color,
            icon: state.icon,
          ) ??
          Tile(
            dashboardID: state.dashboardID,
            type: state.type,
            deviceID: state.selectedDeviceID!,
            attributeID: state.selectedAttributeID!,
            name: state.tileName,
            lob: state.lob,
            color: state.color,
            icon: state.icon,
          );
      await _userRepository.saveTile(tile);
      emit(state.copyWith(status: EditTileStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: EditTileStatus.failure, error: () => err));
      emit(state.copyWith(status: EditTileStatus.normal, error: () => null));
    }
  }
}
