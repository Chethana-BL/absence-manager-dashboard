import 'package:absence_manager_dashboard/features/absence_management/domain/entities/absence.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/entities/member.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_status.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/repositories/absence_repository.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/bloc/absence_list_event.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/bloc/absence_list_state.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/view_models/absence_list_item_vm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AbsenceListBloc extends Bloc<AbsenceListEvent, AbsenceListState> {
  AbsenceListBloc(this.repository)
    : super(
        const AbsenceListState(
          items: [],
          totalCount: 0,
          currentPage: 0,
          totalPages: 1,
          isLoading: true,
        ),
      ) {
    on<LoadAbsences>(_onLoad);
    on<SearchChanged>(_onFilterChanged);
    on<TypeChanged>(_onFilterChanged);
    on<StatusChanged>(_onFilterChanged);
    on<NextPageRequested>(_onNextPage);
    on<PreviousPageRequested>(_onPreviousPage);
  }

  final AbsenceRepository repository;

  static const int _pageSize = 10;

  List<Absence> _allAbsences = [];
  List<Member> _members = [];
  List<Absence> _filtered = [];

  String _search = '';
  AbsenceType? _type;
  AbsenceStatus? _status;

  int _currentPage = 0;

  Future<void> _onLoad(
    LoadAbsences event,
    Emitter<AbsenceListState> emit,
  ) async {
    // Start loading
    emit(state.copyWith(isLoading: true));

    // Fetch data
    try {
      _allAbsences = await repository.getAbsences();
      _members = await repository.getMembers();

      _applyFilters(emit);
    } catch (_) {
      emit(state.copyWith(isLoading: false, hasError: true));
    }
  }

  void _onFilterChanged(
    AbsenceListEvent event,
    Emitter<AbsenceListState> emit,
  ) {
    // Update filters based on event type
    if (event is SearchChanged) _search = event.query.toLowerCase();
    if (event is TypeChanged) _type = event.type;
    if (event is StatusChanged) _status = event.status;

    _currentPage = 0; // reset page on filter change
    _applyFilters(emit);
  }

  void _onNextPage(NextPageRequested event, Emitter<AbsenceListState> emit) {
    // Only go to next page if it exists
    if (_currentPage < _calculateTotalPages() - 1) {
      _currentPage++;
      _emitPage(emit);
    }
  }

  void _onPreviousPage(
    PreviousPageRequested event,
    Emitter<AbsenceListState> emit,
  ) {
    // Only go to previous page if it exists
    if (_currentPage > 0) {
      _currentPage--;
      _emitPage(emit);
    }
  }

  void _applyFilters(Emitter<AbsenceListState> emit) {
    // Create a map for quick member lookup
    final memberByUserId = {for (final m in _members) m.userId: m};

    // Apply filters
    _filtered = _allAbsences.where((a) {
      final name = memberByUserId[a.userId]?.name.toLowerCase() ?? '';

      final matchSearch = _search.isEmpty || name.contains(_search);

      final matchType = _type == null || a.type == _type;

      final matchStatus = _status == null || a.status == _status;

      return matchSearch && matchType && matchStatus;
    }).toList();

    _emitPage(emit);
  }

  void _emitPage(Emitter<AbsenceListState> emit) {
    // Create a map for quick member lookup
    final memberByUserId = {for (final m in _members) m.userId: m};

    final start = _currentPage * _pageSize;
    final end = (start + _pageSize).clamp(0, _filtered.length);

    final pageItems = _filtered.sublist(start, end).map((a) {
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

    emit(
      AbsenceListState(
        items: pageItems,
        totalCount: _filtered.length,
        currentPage: _currentPage,
        totalPages: _calculateTotalPages(),
        isLoading: false,
      ),
    );
  }

  int _calculateTotalPages() {
    // Calculate total pages based on filtered results and page size
    return (_filtered.length / _pageSize)
        .ceil()
        .clamp(1, double.infinity)
        .toInt();
  }
}
