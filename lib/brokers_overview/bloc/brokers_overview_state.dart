part of 'brokers_overview_bloc.dart';

class BrokersOverviewState extends Equatable {
  const BrokersOverviewState({
    required this.parentProject,
    this.brokers = const [],
  });

  final Project parentProject;
  final List<Broker> brokers;

  List<Broker> get showedBrokers =>
      brokers.where((br) => br.projectID == parentProject.id).toList();

  @override
  List<Object> get props => [parentProject, brokers];

  BrokersOverviewState copyWith({
    Project? parentProject,
    List<Broker>? brokers,
  }) {
    return BrokersOverviewState(
      parentProject: parentProject ?? this.parentProject,
      brokers: brokers ?? this.brokers,
    );
  }
}
