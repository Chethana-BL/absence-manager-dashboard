import 'package:absence_manager_dashboard/features/absence_management/domain/entities/absence.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/entities/member.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/repositories/absence_repository.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/bloc/absence_list_event.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/bloc/absence_list_state.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/view_models/absence_list_item_vm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AbsenceListBloc extends Bloc<AbsenceListEvent, AbsenceListState> {
  AbsenceListBloc(this.repository) : super(AbsenceListState.initialLoading()) {
    on<LoadAbsences>(_onLoad);
    on<SearchChanged>(_onFiltersChanged);
    on<TypeChanged>(_onFiltersChanged);
    on<StatusChanged>(_onFiltersChanged);
    on<FromDateChanged>(_onFiltersChanged);
    on<ToDateChanged>(_onFiltersChanged);
    on<ClearFiltersRequested>(_onFiltersChanged);
    on<NextPageRequested>(_onPageChanged);
    on<PreviousPageRequested>(_onPageChanged);
  }

  final AbsenceRepository repository;

  static const int _pageSize = 10;

  List<Absence> _allAbsences = <Absence>[];
  List<Member> _members = <Member>[];

  int _currentPage = 0;

  Future<void> _onLoad(
    LoadAbsences event,
    Emitter<AbsenceListState> emit,
  ) async {
    // Start loading
    emit(state.copyWith(isLoading: true, hasError: false));

    // Fetch data
    try {
      _allAbsences = await repository.getAbsences();
      _members = await repository.getMembers();

      _currentPage = 0; // reset page to first on load
      emit(
        _computeState(base: state.copyWith(isLoading: false, hasError: false)),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false, hasError: true));
    }
  }

  void _onFiltersChanged(
    AbsenceListEvent event,
    Emitter<AbsenceListState> emit,
  ) {
    final updatedState = _reduceFilters(state, event);
    _currentPage = 0; // reset page on filter change

    emit(_computeState(base: updatedState));
  }

  void _onPageChanged(AbsenceListEvent event, Emitter<AbsenceListState> emit) {
    final totalPages = state.totalPages;

    if (event is NextPageRequested) {
      if (_currentPage < totalPages - 1) _currentPage++;
    } else if (event is PreviousPageRequested) {
      if (_currentPage > 0) _currentPage--;
    }

    emit(_computeState(base: state));
  }

  AbsenceListState _reduceFilters(
    AbsenceListState current,
    AbsenceListEvent event,
  ) {
    // Search query changed
    if (event is SearchChanged) {
      return current.copyWith(searchQuery: event.query);
    }

    // Type changed
    if (event is TypeChanged) {
      if (event.type == null) {
        return current.copyWith(setSelectedTypeToNull: true);
      }
      return current.copyWith(selectedType: event.type);
    }

    // Status changed
    if (event is StatusChanged) {
      if (event.status == null) {
        return current.copyWith(setSelectedStatusToNull: true);
      }
      return current.copyWith(selectedStatus: event.status);
    }

    // Clear all filters
    if (event is ClearFiltersRequested) {
      return current.copyWith(
        searchQuery: '',
        setSelectedTypeToNull: true,
        setSelectedStatusToNull: true,
        setFromDateToNull: true,
        setToDateToNull: true,
        hasError: false,
      );
    }

    // Date changed
    if (event is FromDateChanged) {
      final from = event.date;
      var to = current.toDate;

      // If "from" is after "to", adjust "to" to be the same as "from" to maintain a valid date range.
      if (from != null && to != null && from.isAfter(to)) {
        to = from;
      }

      return current.copyWith(
        fromDate: from,
        toDate: to,
        setFromDateToNull: from == null,
      );
    }

    if (event is ToDateChanged) {
      final to = event.date;
      var from = current.fromDate;

      // If "to" is before "from", adjust "from" to be the same as "to" to maintain a valid date range.
      if (from != null && to != null && to.isBefore(from)) {
        from = to;
      }

      return current.copyWith(
        fromDate: from,
        toDate: to,
        setToDateToNull: to == null,
      );
    }

    return current;
  }

  AbsenceListState _computeState({required AbsenceListState base}) {
    final memberByUserId = <int, Member>{for (final m in _members) m.userId: m};

    final q = base.searchQuery.trim().toLowerCase();
    final from = base.fromDate;
    final to = base.toDate;

    final filtered = _allAbsences.where((a) {
      final name = memberByUserId[a.userId]?.name.toLowerCase() ?? '';

      final matchesSearch = q.isEmpty || name.contains(q);
      final matchesType =
          base.selectedType == null || a.type == base.selectedType;
      final matchesStatus =
          base.selectedStatus == null || a.status == base.selectedStatus;

      final matchesFrom =
          from == null || !a.startDate.isBefore(_dateOnly(from));
      final matchesTo = to == null || !a.endDate.isAfter(_dateOnly(to));

      return matchesSearch &&
          matchesType &&
          matchesStatus &&
          matchesFrom &&
          matchesTo;
    }).toList();

    final totalPages = _calculateTotalPages(filtered);

    // Ensure current page is within bounds after filtering
    if (_currentPage > totalPages - 1) {
      _currentPage = totalPages - 1;
    }
    if (_currentPage < 0) _currentPage = 0;

    final filteredVms = filtered.map((a) {
      final name = memberByUserId[a.userId]?.name ?? 'Unknown';
      return AbsenceListItemVm(
        employeeName: name,
        type: a.type,
        startDate: a.startDate,
        endDate: a.endDate,
        memberNote: a.memberNote,
        admitterNote: a.admitterNote,
        status: a.status,
        daysCount: a.daysCount,
      );
    }).toList();

    // Calculate start and end indices for pagination
    final start = _currentPage * _pageSize;
    final end = (start + _pageSize).clamp(0, filteredVms.length);
    final pageItems = filteredVms.sublist(start, end);

    return base.copyWith(
      items: pageItems,
      filteredItems: filteredVms,
      totalCount: filteredVms.length,
      totalPages: totalPages,
      currentPage: _currentPage,
      isLoading: false,
      hasError: base.hasError,
    );
  }

  int _calculateTotalPages(List<Absence> filtered) {
    // Calculate total pages based on filtered results and page size
    return (filtered.length / _pageSize)
        .ceil()
        .clamp(1, double.infinity)
        .toInt();
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
