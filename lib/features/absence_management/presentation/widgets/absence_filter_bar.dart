import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:absence_manager_dashboard/core/utils/date_formatters.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_status.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';
import 'package:flutter/material.dart';

class AbsenceFilterBar extends StatelessWidget {
  const AbsenceFilterBar({
    super.key,
    required this.searchQuery,
    required this.selectedType,
    required this.selectedStatus,
    required this.fromDate,
    required this.toDate,
    required this.onSearch,
    required this.onTypeChanged,
    required this.onStatusChanged,
    required this.onFromDateChanged,
    required this.onToDateChanged,
  });

  final String searchQuery;
  final AbsenceType? selectedType;
  final AbsenceStatus? selectedStatus;
  final DateTime? fromDate;
  final DateTime? toDate;

  final ValueChanged<String> onSearch;
  final ValueChanged<AbsenceType?> onTypeChanged;
  final ValueChanged<AbsenceStatus?> onStatusChanged;
  final ValueChanged<DateTime?> onFromDateChanged;
  final ValueChanged<DateTime?> onToDateChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.space,
      runSpacing: AppSizes.space,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 240,
          child: _EmployeeSearchField(
            initialValue: searchQuery,
            onChanged: onSearch,
          ),
        ),
        SizedBox(
          width: 180,
          child: _AbsenceTypeDropdown(
            value: selectedType,
            onChanged: onTypeChanged,
          ),
        ),
        SizedBox(
          width: 200,
          child: _AbsenceStatusDropdown(
            value: selectedStatus,
            onChanged: onStatusChanged,
          ),
        ),
        SizedBox(
          width: 200,
          child: _DateField(
            label: 'From',
            value: fromDate,
            onPick: () async {
              final picked = await _pickDate(context, fromDate);
              if (picked != null) onFromDateChanged(picked);
            },
            onClear: fromDate == null ? null : () => onFromDateChanged(null),
          ),
        ),
        SizedBox(
          width: 200,
          child: _DateField(
            label: 'To',
            value: toDate,
            onPick: () async {
              final picked = await _pickDate(context, toDate);
              if (picked != null) onToDateChanged(picked);
            },
            onClear: toDate == null ? null : () => onToDateChanged(null),
          ),
        ),
      ],
    );
  }

  Future<DateTime?> _pickDate(BuildContext context, DateTime? initial) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initial ?? DateTime(now.year, now.month, now.day),
      firstDate: DateTime(2000), // arbitrary past date
      lastDate: DateTime(2100), // arbitrary future date
    );
  }
}

class _EmployeeSearchField extends StatelessWidget {
  const _EmployeeSearchField({
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
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
      isExpanded: true,
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
      isExpanded: true,
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
  const _DateField({
    required this.label,
    required this.value,
    required this.onPick,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final text = value == null ? '' : DateFormatters.short.format(value!);

    return TextFormField(
      readOnly: true,
      onTap: onPick,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Select date',
        prefixIcon: const Icon(Icons.calendar_today),
        suffixIcon: onClear == null
            ? null
            : IconButton(onPressed: onClear, icon: const Icon(Icons.clear)),
        border: const OutlineInputBorder(),
      ),
      controller: TextEditingController(text: text),
    );
  }
}
