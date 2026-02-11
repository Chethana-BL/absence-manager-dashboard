import 'package:absence_manager_dashboard/features/absence_management/presentation/view_models/absence_list_item_vm.dart';

class AbsenceListState {
  const AbsenceListState({
    required this.items,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    this.isLoading = false,
    this.hasError = false,
  });

  final List<AbsenceListItemVm> items;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final bool hasError;

  AbsenceListState copyWith({
    List<AbsenceListItemVm>? items,
    int? totalCount,
    int? currentPage,
    int? totalPages,
    bool? isLoading,
    bool? hasError,
  }) {
    return AbsenceListState(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}
