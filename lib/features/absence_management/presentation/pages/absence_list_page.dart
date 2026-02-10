import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:absence_manager_dashboard/core/widgets/primary_gradient_header.dart';
import 'package:absence_manager_dashboard/core/widgets/section_card.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/widgets/absence_filter_bar.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/widgets/absence_table.dart';
import 'package:flutter/material.dart';

class AbsenceListPage extends StatelessWidget {
  const AbsenceListPage({super.key});

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SectionCard(
                          padding: const EdgeInsets.all(AppSizes.paddingLG),
                          child: Column(
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
                              const Row(
                                children: <Widget>[
                                  // TODO: This should be dynamic based on the current filters and search query
                                  _TotalAbsencesPill(total: 142),
                                  Spacer(),
                                ],
                              ),
                              const SizedBox(height: AppSizes.spaceLG),
                              const AbsenceFilterBar(),
                              const SizedBox(height: AppSizes.spaceLG),
                              const AbsenceTable(),
                            ],
                          ),
                        ),
                      ],
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
