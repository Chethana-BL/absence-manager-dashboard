import 'package:absence_manager_dashboard/features/absence_management/domain/entities/absence.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_status.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('daysCount is inclusive', () {
    final a = Absence(
      id: 1,
      crewId: 1,
      userId: 1,
      type: AbsenceType.vacation,
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 1, 3),
      createdAt: DateTime(2024, 12, 1),
    );

    expect(a.daysCount, 3);
  });

  test('status is confirmed when confirmedAt is set', () {
    final a = Absence(
      id: 1,
      crewId: 1,
      userId: 1,
      type: AbsenceType.vacation,
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 1, 1),
      createdAt: DateTime(2024, 12, 1),
      confirmedAt: DateTime(2024, 12, 2),
    );

    expect(a.status, AbsenceStatus.confirmed);
  });

  test('status is rejected when rejectedAt is set', () {
    final a = Absence(
      id: 1,
      crewId: 1,
      userId: 1,
      type: AbsenceType.vacation,
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 1, 1),
      createdAt: DateTime(2024, 12, 1),
      rejectedAt: DateTime(2024, 12, 2),
    );

    expect(a.status, AbsenceStatus.rejected);
  });

  test(
    'status is requested when neither confirmedAt nor rejectedAt is set',
    () {
      final a = Absence(
        id: 1,
        crewId: 1,
        userId: 1,
        type: AbsenceType.vacation,
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 1),
        createdAt: DateTime(2024, 12, 1),
      );

      expect(a.status, AbsenceStatus.requested);
    },
  );
}
