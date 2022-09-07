part of 'records_overview_bloc.dart';

class RecordsOverviewEvent extends Equatable {
  const RecordsOverviewEvent();

  @override
  List<Object?> get props => [];
}

class GetRecords extends RecordsOverviewEvent {
  const GetRecords();
}
