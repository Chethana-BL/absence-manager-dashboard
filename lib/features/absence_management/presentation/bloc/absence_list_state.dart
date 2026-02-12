import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_status.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/view_models/absence_list_item_vm.dart';

class AbsenceListState {
  const AbsenceListState({
    required this.items,
    required this.filteredItems,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.searchQuery,
    required this.selectedType,
    required this.selectedStatus,
    required this.fromDate,
    required this.toDate,
    this.isLoading = false,
    this.hasError = false,
  });

  final List<AbsenceListItemVm> items; // current page
  final List<AbsenceListItemVm> filteredItems; // all filtered

  final int totalCount;
  final int currentPage;
  final int totalPages;

  final String searchQuery;
  final AbsenceType? selectedType;
  final AbsenceStatus? selectedStatus;
  final DateTime? fromDate;
  final DateTime? toDate;

  final bool isLoading;
  final bool hasError;

  AbsenceListState copyWith({
    List<AbsenceListItemVm>? items,
    List<AbsenceListItemVm>? filteredItems,
    int? totalCount,
    int? currentPage,
    int? totalPages,
    String? searchQuery,
    AbsenceType? selectedType,
    AbsenceStatus? selectedStatus,
    DateTime? fromDate,
    DateTime? toDate,
    bool? isLoading,
    bool? hasError,
    bool setSelectedTypeToNull = false,
    bool setSelectedStatusToNull = false,
    bool setFromDateToNull = false,
    bool setToDateToNull = false,
  }) {
    return AbsenceListState(
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: setSelectedTypeToNull
          ? null
          : (selectedType ?? this.selectedType),
      selectedStatus: setSelectedStatusToNull
          ? null
          : (selectedStatus ?? this.selectedStatus),
      fromDate: setFromDateToNull ? null : (fromDate ?? this.fromDate),
      toDate: setToDateToNull ? null : (toDate ?? this.toDate),
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }

  static AbsenceListState initialLoading() {
    return const AbsenceListState(
      items: <AbsenceListItemVm>[],
      filteredItems: <AbsenceListItemVm>[],
      totalCount: 0,
      currentPage: 0,
      totalPages: 1,
      searchQuery: '',
      selectedType: null,
      selectedStatus: null,
      fromDate: null,
      toDate: null,
      isLoading: true,
      hasError: false,
    );
  }
}
