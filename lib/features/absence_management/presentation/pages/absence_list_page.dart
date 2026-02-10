import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:absence_manager_dashboard/core/widgets/primary_gradient_header.dart';
import 'package:absence_manager_dashboard/core/widgets/section_card.dart';
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: const Padding(
                  padding: EdgeInsets.all(AppSizes.paddingLG),
                  child: SectionCard(
                    child: Text('Absence list will appear here'),
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
