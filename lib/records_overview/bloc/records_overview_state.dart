part of 'records_overview_bloc.dart';

enum RecordsOverviewStatus {
  normal,
  processing,
  success,
  failure,
}

extension RecordsOverviewStatusX on RecordsOverviewStatus {
  bool isProcessing() => this == RecordsOverviewStatus.processing;
  bool isSuccess() => this == RecordsOverviewStatus.success;
  bool isFailure() => this == RecordsOverviewStatus.failure;
}

class RecordsOverviewState extends Equatable {
  const RecordsOverviewState({
    this.status = RecordsOverviewStatus.processing,
    required this.device,
    required this.attributes,
    this.trackingDevices = const [],
    this.trackingAttributes = const [],
    this.error,
  });

  // immutate
  final Device device;

  // listen
  final List<TrackingDevice> trackingDevices;
  final List<TrackingAttribute> trackingAttributes;
  final List<Attribute> attributes;


  // status
  final RecordsOverviewStatus status;
  final String? error;

  @override
  List<Object?> get props => [
        device,
        attributes,
        trackingDevices,
        trackingAttributes,
        status,
        error
      ];

  RecordsOverviewState copyWith({
    Device? device,
    List<Attribute>? attributes,
    List<TrackingDevice>? trackingDevices,
    List<TrackingAttribute>? trackingAttributes,
    RecordsOverviewStatus? status,
    String? Function()? error,
  }) {
    return RecordsOverviewState(
      device: device ?? this.device,
      attributes: attributes ?? this.attributes,
      trackingDevices: trackingDevices ?? this.trackingDevices,
      trackingAttributes: trackingAttributes ?? this.trackingAttributes,
      status: status ?? this.status,
      error: error != null ? error() : this.error,
    );
  }
}
