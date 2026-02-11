import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/view_models/absence_list_item_vm.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class AbsenceTable extends StatelessWidget {
  const AbsenceTable({super.key, required this.rows});

  final List<AbsenceListItemVm> rows;

  static const double _employeeW = 180;
  static const double _typeW = 120;
  static const double _periodW = 210;
  static const double _memberNoteW = 220;
  static const double _admitterNoteW = 220;
  static const double _statusW = 130;
  static const double _daysW = 80;

  static const double _tableMinWidth =
      _employeeW +
      _typeW +
      _periodW +
      _memberNoteW +
      _admitterNoteW +
      _statusW +
      _daysW +
      (AppSizes.paddingLG * 2);

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: _tableMinWidth),
        child: Column(
          children: <Widget>[
            _TableHeader(style: headerStyle),
            const SizedBox(height: AppSizes.spaceSM),
            ...rows.map((row) => _TableRowItem(row: row)),
          ],
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.style});

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingLG,
        vertical: AppSizes.paddingSM,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _Cell(
            width: AbsenceTable._employeeW,
            child: Text('Employee', style: style),
          ),
          _Cell(
            width: AbsenceTable._typeW,
            child: Text('Type', style: style),
          ),
          _Cell(
            width: AbsenceTable._periodW,
            child: Text('Period', style: style),
          ),
          _Cell(
            width: AbsenceTable._memberNoteW,
            child: Text('Member note', style: style),
          ),
          _Cell(
            width: AbsenceTable._admitterNoteW,
            child: Text('Admitter note', style: style),
          ),
          _Cell(
            width: AbsenceTable._statusW,
            child: Text('Status', style: style),
          ),
          _Cell(
            width: AbsenceTable._daysW,
            child: Text('Days', style: style),
          ),
        ],
      ),
    );
  }
}

class _TableRowItem extends StatelessWidget {
  const _TableRowItem({required this.row});

  final AbsenceListItemVm row;

  @override
  Widget build(BuildContext context) {
    final period = '${_fmt(row.startDate)} → ${_fmt(row.endDate)}';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceSM),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLG,
          vertical: AppSizes.paddingSM,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _Cell(
              width: AbsenceTable._employeeW,
              child: Text(row.employeeName),
            ),
            _Cell(width: AbsenceTable._typeW, child: Text(row.type.label)),
            _Cell(width: AbsenceTable._periodW, child: Text(period)),
            _Cell(
              width: AbsenceTable._memberNoteW,
              child: Text(row.memberNote ?? '-'),
            ),
            _Cell(
              width: AbsenceTable._admitterNoteW,
              child: Text(row.admitterNote ?? '-'),
            ),
            _Cell(
              width: AbsenceTable._statusW,
              child: StatusBadge(status: row.status),
            ),
            _Cell(
              width: AbsenceTable._daysW,
              child: Text(row.daysCount.toString()),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Align(alignment: Alignment.centerLeft, child: child),
    );
  }
}
