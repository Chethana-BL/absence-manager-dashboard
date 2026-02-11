import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_status.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';
import 'package:flutter/material.dart';

class AbsenceFilterBar extends StatelessWidget {
  const AbsenceFilterBar({
    super.key,
    required this.onSearch,
    required this.onTypeChanged,
    required this.onStatusChanged,
  });

  final ValueChanged<String> onSearch;
  final ValueChanged<AbsenceType?> onTypeChanged;
  final ValueChanged<AbsenceStatus?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.space,
      runSpacing: AppSizes.space,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 280,
          child: _EmployeeSearchField(onSearchChanged: onSearch),
        ),
        SizedBox(
          width: 180,
          child: _AbsenceTypeDropdown(value: null, onChanged: onTypeChanged),
        ),
        SizedBox(
          width: 200,
          child: _AbsenceStatusDropdown(
            value: null,
            onChanged: onStatusChanged,
          ),
        ),
        const SizedBox(width: 180, child: _DateField(label: 'From')),
        const SizedBox(width: 180, child: _DateField(label: 'To')),
      ],
    );
  }
}

class _EmployeeSearchField extends StatelessWidget {
  const _EmployeeSearchField({required this.onSearchChanged});

  final ValueChanged<String>? onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearchChanged,
      decoration: const InputDecoration(
        labelText: 'Search employee',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _AbsenceTypeDropdown extends StatelessWidget {
  const _AbsenceTypeDropdown({required this.value, required this.onChanged});

  final AbsenceType? value;
  final ValueChanged<AbsenceType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AbsenceType?>(
      initialValue: value,
      items: <DropdownMenuItem<AbsenceType?>>[
        const DropdownMenuItem<AbsenceType?>(
          value: null,
          child: Text('All types'),
        ),
        ...AbsenceType.values.map(
          (AbsenceType e) =>
              DropdownMenuItem<AbsenceType?>(value: e, child: Text(e.label)),
        ),
      ],
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Type',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _AbsenceStatusDropdown extends StatelessWidget {
  const _AbsenceStatusDropdown({required this.value, required this.onChanged});

  final AbsenceStatus? value;
  final ValueChanged<AbsenceStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AbsenceStatus?>(
      initialValue: value,
      items: <DropdownMenuItem<AbsenceStatus?>>[
        const DropdownMenuItem<AbsenceStatus?>(
          value: null,
          child: Text('All statuses'),
        ),
        ...AbsenceStatus.values.map(
          (AbsenceStatus s) =>
              DropdownMenuItem<AbsenceStatus?>(value: s, child: Text(s.label)),
        ),
      ],
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calendar_today),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
