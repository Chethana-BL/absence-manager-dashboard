import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_status.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class AbsenceTable extends StatelessWidget {
  const AbsenceTable({super.key});

  // TODO: Sample data for demonstration purposes. will be replaced with real data fetching logic.
  static final List<_AbsenceRow> _rows = <_AbsenceRow>[
    const _AbsenceRow(
      employeeName: 'Mike Ross',
      type: AbsenceType.vacation,
      period: '2021-07-01 → 2021-07-03',
      memberNote: 'Family trip',
      admitterNote: 'Approved',
      status: AbsenceStatus.confirmed,
      days: 3,
    ),
    const _AbsenceRow(
      employeeName: 'Rachel Zane',
      type: AbsenceType.sickness,
      period: '2021-07-10 → 2021-07-10',
      memberNote: 'Flu',
      admitterNote: '',
      status: AbsenceStatus.requested,
      days: 1,
    ),
    const _AbsenceRow(
      employeeName: 'Harvey Specter',
      type: AbsenceType.vacation,
      period: '2021-07-15 → 2021-07-20',
      memberNote: '',
      admitterNote: 'Too many conflicts',
      status: AbsenceStatus.rejected,
      days: 6,
    ),
    const _AbsenceRow(
      employeeName: 'Donna Paulsen',
      type: AbsenceType.vacation,
      period: '2021-08-01 → 2021-08-05',
      memberNote: 'Travel',
      admitterNote: 'Approved',
      status: AbsenceStatus.confirmed,
      days: 5,
    ),
    const _AbsenceRow(
      employeeName: 'Louis Litt',
      type: AbsenceType.sickness,
      period: '2021-08-12 → 2021-08-13',
      memberNote: 'Doctor visit',
      admitterNote: '',
      status: AbsenceStatus.requested,
      days: 2,
    ),
    const _AbsenceRow(
      employeeName: 'Jessica Pearson',
      type: AbsenceType.vacation,
      period: '2021-09-05 → 2021-09-07',
      memberNote: '',
      admitterNote: 'Approved',
      status: AbsenceStatus.confirmed,
      days: 3,
    ),
    const _AbsenceRow(
      employeeName: 'Alex Williams',
      type: AbsenceType.sickness,
      period: '2021-09-18 → 2021-09-18',
      memberNote: 'Migraine',
      admitterNote: '',
      status: AbsenceStatus.requested,
      days: 1,
    ),
    const _AbsenceRow(
      employeeName: 'Katrina Bennett',
      type: AbsenceType.vacation,
      period: '2021-10-02 → 2021-10-04',
      memberNote: 'Wedding',
      admitterNote: 'Approved',
      status: AbsenceStatus.confirmed,
      days: 3,
    ),
    const _AbsenceRow(
      employeeName: 'Benjamin',
      type: AbsenceType.sickness,
      period: '2021-10-10 → 2021-10-11',
      memberNote: '',
      admitterNote: 'Provide certificate',
      status: AbsenceStatus.requested,
      days: 2,
    ),
    const _AbsenceRow(
      employeeName: 'Gretchen',
      type: AbsenceType.vacation,
      period: '2021-10-20 → 2021-10-22',
      memberNote: 'Family',
      admitterNote: 'Approved',
      status: AbsenceStatus.confirmed,
      days: 3,
    ),
  ];

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
            ..._rows.map((row) => _TableRowItem(row: row)),
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
      child: _RowCells(
        employee: Text('Employee', style: style),
        type: Text('Type', style: style),
        period: Text('Period', style: style),
        memberNote: Text('Member note', style: style),
        admitterNote: Text('Admitter note', style: style),
        status: Text('Status', style: style),
        days: Text('Days', style: style),
      ),
    );
  }
}

class _TableRowItem extends StatelessWidget {
  const _TableRowItem({required this.row});

  final _AbsenceRow row;

  @override
  Widget build(BuildContext context) {
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
        child: _RowCells(
          employee: Text(row.employeeName),
          type: Text(row.type.label),
          period: Text(row.period),
          memberNote: Text(row.memberNote.isEmpty ? '-' : row.memberNote),
          admitterNote: Text(row.admitterNote.isEmpty ? '-' : row.admitterNote),
          status: StatusBadge(status: row.status),
          days: Text(row.days.toString()),
        ),
      ),
    );
  }
}

class _RowCells extends StatelessWidget {
  const _RowCells({
    required this.employee,
    required this.type,
    required this.period,
    required this.memberNote,
    required this.admitterNote,
    required this.status,
    required this.days,
    this.style,
  });

  final Widget employee;
  final Widget type;
  final Widget period;
  final Widget memberNote;
  final Widget admitterNote;
  final Widget status;
  final Widget days;
  final TextStyle? style;

  _RowCells withStyle(TextStyle? style) {
    return _RowCells(
      employee: employee,
      type: type,
      period: period,
      memberNote: memberNote,
      admitterNote: admitterNote,
      status: status,
      days: days,
      style: style,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget wrap(Widget child) {
      if (style == null || child is! Text) return child;
      return Text(child.data ?? '', style: style);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _Cell(width: AbsenceTable._employeeW, child: wrap(employee)),
        _Cell(width: AbsenceTable._typeW, child: wrap(type)),
        _Cell(width: AbsenceTable._periodW, child: wrap(period)),
        _Cell(width: AbsenceTable._memberNoteW, child: wrap(memberNote)),
        _Cell(width: AbsenceTable._admitterNoteW, child: wrap(admitterNote)),
        _Cell(width: AbsenceTable._statusW, child: status),
        _Cell(width: AbsenceTable._daysW, child: wrap(days)),
      ],
    );
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

class _AbsenceRow {
  const _AbsenceRow({
    required this.employeeName,
    required this.type,
    required this.period,
    required this.memberNote,
    required this.admitterNote,
    required this.status,
    required this.days,
  });

  final String employeeName;
  final AbsenceType type;
  final String period;
  final String memberNote;
  final String admitterNote;
  final AbsenceStatus status;
  final int days;
}
