import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:absence_manager_dashboard/core/widgets/primary_gradient_header.dart';
import 'package:absence_manager_dashboard/core/widgets/section_card.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/datasources/absence_local_data_source.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/repositories/absence_repository_impl.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/entities/member.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/view_models/absence_list_item_vm.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/widgets/absence_filter_bar.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/widgets/absence_table.dart';
import 'package:flutter/material.dart';

class AbsenceListPage extends StatefulWidget {
  const AbsenceListPage({super.key});

  @override
  State<AbsenceListPage> createState() => _AbsenceListPageState();
}

class _AbsenceListPageState extends State<AbsenceListPage> {
  late final Future<_AbsencePageData> _future;

  @override
  void initState() {
    super.initState();
    final repo = const AbsenceRepositoryImpl(
      localDataSource: AbsenceLocalDataSourceImpl(),
    );
    _future = _load(repo);
  }

  Future<_AbsencePageData> _load(AbsenceRepositoryImpl repo) async {
    final absences = await repo.getAbsences();
    final members = await repo.getMembers();

    final memberByUserId = <int, Member>{for (final m in members) m.userId: m};

    final items = absences.map((a) {
      final memberName = memberByUserId[a.userId]?.name ?? 'Unknown';
      return AbsenceListItemVm(
        employeeName: memberName,
        type: a.type,
        startDate: a.startDate,
        endDate: a.endDate,
        memberNote: a.memberNote,
        admitterNote: a.admitterNote,
        status: a.status,
        daysCount: a.daysCount,
      );
    }).toList();

    final pageItems = items.take(10).toList();

    return _AbsencePageData(totalAbsences: items.length, pageItems: pageItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
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
                      child: FutureBuilder<_AbsencePageData>(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(AppSizes.paddingLG),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Failed to load data'),
                            );
                          }

                          final data = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
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
                              _TotalAbsencesPill(total: data.totalAbsences),
                              const SizedBox(height: AppSizes.spaceLG),
                              const AbsenceFilterBar(),
                              const SizedBox(height: AppSizes.spaceLG),
                              AbsenceTable(rows: data.pageItems),
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
    );
  }
}

//
class _AbsencePageData {
  const _AbsencePageData({
    required this.totalAbsences,
    required this.pageItems,
  });

  final int totalAbsences;
  final List<AbsenceListItemVm> pageItems;
}

class _TotalAbsencesPill extends StatelessWidget {
  const _TotalAbsencesPill({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLG,
          vertical: AppSizes.paddingSM,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Total absences',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: AppSizes.spaceSM),
            Text(
              total.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
