import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'records_overview_event.dart';
part 'records_overview_state.dart';

class RecordsOverviewBloc
    extends Bloc<RecordsOverviewEvent, RecordsOverviewState> {
  RecordsOverviewBloc(
    this._userRepository, {
    required Device device,
    required List<Attribute> attributes,
  }) : super(RecordsOverviewState(device: device, attributes: attributes)) {
    on<GetRecords>(_onGetRecord);
  }

  final UserRepository _userRepository;

  Future<void> _onGetRecord(
    GetRecords event,
    Emitter<RecordsOverviewState> emit,
  ) async {
    try {
      emit(state.copyWith(status: RecordsOverviewStatus.processing));
      final data = await _userRepository.getRecords(state.device.id);
      final _trackingDevices = data['tracking-devices'] as List<dynamic>;
      final _trackingAttributes = data['tracking-attributes'] as List<dynamic>;
      final trackingDevices = _trackingDevices
          .map<TrackingDevice>(
            (json) => TrackingDevice.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      final trackingAttributes = _trackingAttributes
          .map<TrackingAttribute>(
            (json) => TrackingAttribute.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      emit(
        state.copyWith(
          status: RecordsOverviewStatus.success,
          trackingDevices: trackingDevices.reversed.toList(),
          trackingAttributes: trackingAttributes,
        ),
      );
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(
        state.copyWith(
          status: RecordsOverviewStatus.failure,
          error: () => err,
        ),
      );
      emit(
        state.copyWith(
          status: RecordsOverviewStatus.normal,
          error: () => null,
        ),
      );
    }
  }
}
