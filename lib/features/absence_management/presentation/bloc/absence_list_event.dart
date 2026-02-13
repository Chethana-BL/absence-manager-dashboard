import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_status.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';

abstract class AbsenceListEvent {}

class LoadAbsences extends AbsenceListEvent {}

class SearchChanged extends AbsenceListEvent {
  SearchChanged(this.query);
  final String query;
}

class TypeChanged extends AbsenceListEvent {
  TypeChanged(this.type);
  final AbsenceType? type;
}

class StatusChanged extends AbsenceListEvent {
  StatusChanged(this.status);
  final AbsenceStatus? status;
}

class FromDateChanged extends AbsenceListEvent {
  FromDateChanged(this.date);
  final DateTime? date;
}

class ToDateChanged extends AbsenceListEvent {
  ToDateChanged(this.date);
  final DateTime? date;
}

class NextPageRequested extends AbsenceListEvent {}

class PreviousPageRequested extends AbsenceListEvent {}

class ClearFiltersRequested extends AbsenceListEvent {}
