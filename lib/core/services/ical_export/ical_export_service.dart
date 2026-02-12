import 'package:absence_manager_dashboard/features/absence_management/presentation/view_models/absence_list_item_vm.dart';

abstract class ICalExportService {
  Future<void> export(List<AbsenceListItemVm> items);

  String buildIcsContent(List<AbsenceListItemVm> items) {
    final buffer = StringBuffer()
      ..writeln('BEGIN:VCALENDAR')
      ..writeln('VERSION:2.0')
      ..writeln('PRODID:-//absence-manager-dashboard//Absence Manager//EN')
      ..writeln('CALSCALE:GREGORIAN')
      ..writeln('METHOD:PUBLISH');

    for (final a in items) {
      final start = _dateOnly(a.startDate);
      final endExclusive = _dateOnly(a.endDate).add(const Duration(days: 1));

      final uid = _buildUid(a, start, endExclusive);
      final summary = _escape('${a.type.label} — ${a.employeeName}');

      final descLines = <String>[
        'Status: ${a.status.label}',
        if ((a.memberNote ?? '').trim().isNotEmpty)
          'Member note: ${a.memberNote!.trim()}',
      ];
      final description = _escape(descLines.join('\n'));

      buffer
        ..writeln('BEGIN:VEVENT')
        ..writeln('UID:$uid')
        ..writeln('DTSTAMP:${_formatDate(DateTime.now())}')
        ..writeln('DTSTART;VALUE=DATE:${_formatDate(start)}')
        ..writeln('DTEND;VALUE=DATE:${_formatDate(endExclusive)}')
        ..writeln('SUMMARY:$summary')
        ..writeln('DESCRIPTION:$description')
        ..writeln('END:VEVENT');
    }

    buffer.writeln('END:VCALENDAR');
    return buffer.toString();
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  String _formatDate(DateTime dt) {
    return '${dt.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';
  }

  String _escape(String s) {
    return s
        .replaceAll(r'\', r'\\')
        .replaceAll('\n', r'\n')
        .replaceAll(',', r'\,')
        .replaceAll(';', r'\;');
  }

  String _buildUid(AbsenceListItemVm a, DateTime start, DateTime endExclusive) {
    final base = Object.hash(
      a.employeeName,
      a.type,
      start.toIso8601String(),
      endExclusive.toIso8601String(),
    ).toUnsigned(32);
    return 'absence-$base@absence-manager';
  }
}
