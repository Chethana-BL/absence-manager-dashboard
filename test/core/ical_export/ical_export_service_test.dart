import 'package:absence_manager_dashboard/core/services/ical_export/ical_export_service.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_status.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/view_models/absence_list_item_vm.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestIcalService extends ICalExportService {
  @override
  Future<void> export(List<AbsenceListItemVm> items) async {}
}

void main() {
  group('ICalExportService.buildIcsContent', () {
    test('generates a VCALENDAR with VEVENT entries', () {
      final svc = _TestIcalService();

      final items = <AbsenceListItemVm>[
        AbsenceListItemVm(
          employeeName: 'Alice',
          type: AbsenceType.vacation,
          startDate: DateTime(2026, 2, 10),
          endDate: DateTime(2026, 2, 12),
          memberNote: 'Trip',
          admitterNote: null,
          status: AbsenceStatus.confirmed,
          daysCount: 3,
        ),
      ];

      final ics = svc.buildIcsContent(items);

      expect(ics, contains('BEGIN:VCALENDAR'));
      expect(ics, contains('VERSION:2.0'));
      expect(ics, contains('BEGIN:VEVENT'));
      expect(ics, contains('END:VEVENT'));
      expect(ics, contains('END:VCALENDAR'));
    });

    test('formats SUMMARY as "Type — Employee"', () {
      final svc = _TestIcalService();

      final items = <AbsenceListItemVm>[
        AbsenceListItemVm(
          employeeName: 'Alice',
          type: AbsenceType.vacation,
          startDate: DateTime(2026, 2, 10),
          endDate: DateTime(2026, 2, 10),
          memberNote: null,
          admitterNote: null,
          status: AbsenceStatus.confirmed,
          daysCount: 1,
        ),
      ];

      final ics = svc.buildIcsContent(items);

      expect(ics, contains('SUMMARY:Vacation — Alice'));
    });

    test('includes Status and Member note in DESCRIPTION when available', () {
      final svc = _TestIcalService();

      final items = <AbsenceListItemVm>[
        AbsenceListItemVm(
          employeeName: 'Bob',
          type: AbsenceType.sickness,
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 1, 2),
          memberNote: 'High fever',
          admitterNote: null,
          status: AbsenceStatus.rejected,
          daysCount: 2,
        ),
      ];

      final ics = svc.buildIcsContent(items);

      expect(ics, contains('DESCRIPTION:'));
      expect(ics, contains(r'Status: Rejected'));
      expect(ics, contains(r'Member note: High fever'));
    });

    test('omits Member note line when memberNote is null/blank', () {
      final svc = _TestIcalService();

      final items = <AbsenceListItemVm>[
        AbsenceListItemVm(
          employeeName: 'Bob',
          type: AbsenceType.sickness,
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 1, 1),
          memberNote: '   ',
          admitterNote: null,
          status: AbsenceStatus.confirmed,
          daysCount: 1,
        ),
      ];

      final ics = svc.buildIcsContent(items);

      expect(ics, contains(r'Status: Confirmed'));
      expect(ics, isNot(contains('Member note:')));
    });

    test('escapes commas, semicolons, backslashes, and newlines', () {
      final svc = _TestIcalService();

      final items = <AbsenceListItemVm>[
        AbsenceListItemVm(
          employeeName: r'Alice,; \',
          type: AbsenceType.vacation,
          startDate: DateTime(2026, 2, 10),
          endDate: DateTime(2026, 2, 10),
          memberNote: 'Line1\nLine2,; \\',
          admitterNote: null,
          status: AbsenceStatus.requested,
          daysCount: 1,
        ),
      ];

      final ics = svc.buildIcsContent(items);

      // SUMMARY should escape comma/semicolon/backslash
      expect(ics, contains(r'SUMMARY:Vacation — Alice\,\; \\'));
      // DESCRIPTION should escape newline and punctuation/backslash
      expect(
        ics,
        contains(
          r'DESCRIPTION:Status: Requested\nMember note: Line1\nLine2\,\; \\',
        ),
      );
    });

    test('generates a deterministic UID for the same input', () {
      final svc = _TestIcalService();

      final item = AbsenceListItemVm(
        employeeName: 'Alice',
        type: AbsenceType.vacation,
        startDate: DateTime(2026, 2, 10),
        endDate: DateTime(2026, 2, 12),
        memberNote: 'Trip',
        admitterNote: null,
        status: AbsenceStatus.confirmed,
        daysCount: 3,
      );

      final ics1 = svc.buildIcsContent([item]);
      final ics2 = svc.buildIcsContent([item]);

      final uid1 = _extractLine(ics1, 'UID:');
      final uid2 = _extractLine(ics2, 'UID:');

      expect(uid1, isNotNull);
      expect(uid1, equals(uid2));
      expect(uid1, contains('@absence-manager'));
    });
  });
}

String? _extractLine(String content, String prefix) {
  for (final line in content.split('\n')) {
    if (line.startsWith(prefix)) return line.trim();
  }
  return null;
}
