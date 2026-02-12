import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:absence_manager_dashboard/core/widgets/primary_gradient_header.dart';
import 'package:absence_manager_dashboard/core/widgets/section_card.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/datasources/absence_local_data_source.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/repositories/absence_repository_impl.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/bloc/absence_list_bloc.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/bloc/absence_list_event.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/bloc/absence_list_state.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/widgets/absence_filter_bar.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/widgets/absence_table.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/widgets/pagination_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AbsenceListPage extends StatelessWidget {
  const AbsenceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = const AbsenceRepositoryImpl(
      localDataSource: AbsenceLocalDataSourceImpl(),
    );

    return BlocProvider(
      create: (_) => AbsenceListBloc(repository)..add(LoadAbsences()),
      child: Scaffold(
        body: Column(
          children: [
            const PrimaryGradientHeader(
              title: 'Absence Manager',
              subtitle:
                  'View, filter, and manage employee absences including vacations and sick leave',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingLG),
                      child: SectionCard(
                        padding: const EdgeInsets.all(AppSizes.paddingLG),
                        child: BlocBuilder<AbsenceListBloc, AbsenceListState>(
                          builder: (context, state) {
                            if (state.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (state.hasError) {
                              return const Center(
                                child: Text('Failed to load data'),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Absences',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        // TODO: Implement export functionality
                                      },
                                      child: const Text('Export iCal'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSizes.space),

                                _TotalAbsencesPill(total: state.totalCount),

                                const SizedBox(height: AppSizes.spaceLG),

                                AbsenceFilterBar(
                                  searchQuery: state.searchQuery,
                                  selectedType: state.selectedType,
                                  selectedStatus: state.selectedStatus,
                                  fromDate: state.fromDate,
                                  toDate: state.toDate,
                                  onSearch: (value) => context
                                      .read<AbsenceListBloc>()
                                      .add(SearchChanged(value)),
                                  onTypeChanged: (type) => context
                                      .read<AbsenceListBloc>()
                                      .add(TypeChanged(type)),
                                  onStatusChanged: (status) => context
                                      .read<AbsenceListBloc>()
                                      .add(StatusChanged(status)),
                                  onFromDateChanged: (date) => context
                                      .read<AbsenceListBloc>()
                                      .add(FromDateChanged(date)),
                                  onToDateChanged: (date) => context
                                      .read<AbsenceListBloc>()
                                      .add(ToDateChanged(date)),
                                ),

                                const SizedBox(height: AppSizes.spaceLG),

                                AbsenceTable(rows: state.items),

                                const SizedBox(height: AppSizes.spaceLG),

                                PaginationBar(
                                  currentPage: state.currentPage,
                                  totalPages: state.totalPages,
                                  onNext: () => context
                                      .read<AbsenceListBloc>()
                                      .add(NextPageRequested()),
                                  onPrevious: () => context
                                      .read<AbsenceListBloc>()
                                      .add(PreviousPageRequested()),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalAbsencesPill extends StatelessWidget {
  const _TotalAbsencesPill({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Text('Total absences: $total');
  }
}
