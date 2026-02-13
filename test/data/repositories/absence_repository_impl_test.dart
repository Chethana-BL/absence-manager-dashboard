import 'package:absence_manager_dashboard/features/absence_management/data/datasources/absence_data_source.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/models/absence_model.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/models/member_model.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/repositories/absence_repository_impl.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/entities/absence.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/entities/member.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataSource extends Mock implements AbsenceDataSource {}

void main() {
  late MockDataSource dataSource;
  late AbsenceRepositoryImpl repo;

  final absenceModel = AbsenceModel(
    id: 1,
    userId: 1,
    type: AbsenceType.vacation,
    startDate: DateTime.parse('2024-01-01'),
    endDate: DateTime.parse('2024-01-02'),
    confirmedAt: DateTime.parse('2026-04-19T14:35:11.000+02:00'),
    crewId: 352,
    createdAt: DateTime.parse('2026-04-19T11:20:48.000+02:00'),
  );

  final memberModel = const MemberModel(
    id: 1,
    name: 'John Doe',
    crewId: 352,
    userId: 644,
  );

  setUp(() {
    dataSource = MockDataSource();
    repo = AbsenceRepositoryImpl(dataSource: dataSource);
  });

  test('maps absence models to entities', () async {
    when(
      () => dataSource.getAbsences(),
    ).thenAnswer((_) async => [absenceModel]);

    final result = await repo.getAbsences();
    expect(result.first, isA<Absence>());

    final absence = result.first;
    expect(absence.crewId, 352);
    expect(absence.userId, 1);
    expect(absence.type, AbsenceType.vacation);
    expect(absence.startDate, DateTime.parse('2024-01-01'));
    expect(absence.endDate, DateTime.parse('2024-01-02'));
    expect(absence.createdAt, DateTime.parse('2026-04-19T11:20:48.000+02:00'));
    expect(
      absence.confirmedAt,
      DateTime.parse('2026-04-19T14:35:11.000+02:00'),
    );
    expect(absence.admitterId, null);
    expect(absence.memberNote, null);
    expect(absence.admitterNote, null);
    expect(absence.rejectedAt, null);
  });

  test('maps member models to entities', () async {
    when(() => dataSource.getMembers()).thenAnswer((_) async => [memberModel]);

    final result = await repo.getMembers();
    expect(result.first, isA<Member>());

    final member = result.first;
    expect(member.id, 1);
    expect(member.name, 'John Doe');
    expect(member.crewId, 352);
    expect(member.userId, 644);
    expect(member.image, null);
  });
}
