import 'package:absence_manager_dashboard/features/absence_management/domain/entities/absence.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/entities/member.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_status.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/repositories/absence_repository.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/bloc/absence_list_bloc.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/bloc/absence_list_event.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/bloc/absence_list_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAbsenceRepository implements AbsenceRepository {
  FakeAbsenceRepository({
    required this.absences,
    required this.members,
    this.throwOnLoad = false,
  });

  final List<Absence> absences;
  final List<Member> members;
  final bool throwOnLoad;

  @override
  Future<List<Absence>> getAbsences() async {
    if (throwOnLoad) throw Exception('load failed');
    return absences;
  }

  @override
  Future<List<Member>> getMembers() async {
    if (throwOnLoad) throw Exception('load failed');
    return members;
  }
}

void main() {
  group('AbsenceListBloc', () {
    late FakeAbsenceRepository repository;

    setUp(() {
      final members = <Member>[
        const Member(id: 1, name: 'Alice', userId: 1, crewId: 1),
        const Member(id: 2, name: 'Bob', userId: 2, crewId: 1),
        const Member(id: 3, name: 'Charlie', userId: 3, crewId: 1),
      ];

      final absences = <Absence>[
        ..._buildAbsencesForUser(
          userId: 1,
          crewId: 1,
          count: 11,
          type: AbsenceType.vacation,
          status: AbsenceStatus.confirmed,
        ),
        ..._buildAbsencesForUser(
          userId: 2,
          crewId: 1,
          count: 7,
          type: AbsenceType.sickness,
          status: AbsenceStatus.requested,
        ),
        ..._buildAbsencesForUser(
          userId: 3,
          crewId: 1,
          count: 3,
          type: AbsenceType.vacation,
          status: AbsenceStatus.rejected,
        ),
      ];

      repository = FakeAbsenceRepository(absences: absences, members: members);
    });

    test('initial state is loading', () {
      final bloc = AbsenceListBloc(repository);
      expect(bloc.state.isLoading, true);
      expect(bloc.state.items, isEmpty);
      expect(bloc.state.totalCount, 0);
      expect(bloc.state.currentPage, 0);
      expect(bloc.state.totalPages, 1);
    });

    blocTest<AbsenceListBloc, AbsenceListState>(
      'loads data and emits first page of items (10 per page)',
      build: () => AbsenceListBloc(repository),
      act: (bloc) => bloc.add(LoadAbsences()),
      expect: () => <Matcher>[
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AbsenceListState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.hasError, 'hasError', false)
            .having((s) => s.totalCount, 'totalCount', 21)
            .having((s) => s.totalPages, 'totalPages', 3)
            .having((s) => s.currentPage, 'currentPage', 0)
            .having((s) => s.items.length, 'items.length', 10),
      ],
    );

    blocTest<AbsenceListBloc, AbsenceListState>(
      'filters by search query (employee name)',
      build: () => AbsenceListBloc(repository),
      act: (bloc) async {
        bloc.add(LoadAbsences());
        await bloc.stream.firstWhere(
          (s) => !s.isLoading && !s.hasError,
        ); // wait for load to finish
        bloc.add(SearchChanged('ali'));
      },
      expect: () => <Matcher>[
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AbsenceListState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.totalCount, 'totalCount', 21),
        isA<AbsenceListState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.totalCount, 'totalCount', 11)
            .having((s) => s.currentPage, 'currentPage', 0)
            .having((s) => s.items.length, 'items.length', 10),
      ],
    );

    blocTest<AbsenceListBloc, AbsenceListState>(
      'filters by type',
      build: () => AbsenceListBloc(repository),
      act: (bloc) async {
        bloc.add(LoadAbsences());
        await bloc.stream.firstWhere(
          (s) => !s.isLoading && !s.hasError,
        ); // wait for load to finish
        bloc.add(TypeChanged(AbsenceType.sickness));
      },
      expect: () => <Matcher>[
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AbsenceListState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.totalCount, 'totalCount', 21),
        isA<AbsenceListState>()
            .having((s) => s.totalCount, 'totalCount', 7)
            .having((s) => s.totalPages, 'totalPages', 1)
            .having((s) => s.items.length, 'items.length', 7),
      ],
    );

    blocTest<AbsenceListBloc, AbsenceListState>(
      'filters by status',
      build: () => AbsenceListBloc(repository),
      act: (bloc) async {
        bloc.add(LoadAbsences());
        await bloc.stream.firstWhere(
          (s) => !s.isLoading && !s.hasError,
        ); // wait for load to finish
        bloc.add(StatusChanged(AbsenceStatus.rejected));
      },
      expect: () => <Matcher>[
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AbsenceListState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.totalCount, 'totalCount', 21),
        isA<AbsenceListState>()
            .having((s) => s.totalCount, 'totalCount', 3)
            .having((s) => s.items.length, 'items.length', 3),
      ],
    );

    blocTest<AbsenceListBloc, AbsenceListState>(
      'clears filters and resets list/pagination',
      build: () => AbsenceListBloc(repository),
      act: (bloc) async {
        bloc.add(LoadAbsences());
        await bloc.stream.firstWhere((s) => !s.isLoading && !s.hasError);

        // Apply some filters first
        bloc.add(SearchChanged('ali'));
        await bloc.stream.firstWhere((s) => s.totalCount == 11);

        bloc.add(TypeChanged(AbsenceType.vacation));
        await bloc.stream.firstWhere((s) => s.totalCount == 11);

        // Now clear filters
        bloc.add(ClearFiltersRequested());
      },
      expect: () => <Matcher>[
        // initial load
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AbsenceListState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.hasError, 'hasError', false)
            .having((s) => s.totalCount, 'totalCount', 21),

        // after SearchChanged('ali')
        isA<AbsenceListState>()
            .having((s) => s.searchQuery, 'searchQuery', 'ali')
            .having((s) => s.totalCount, 'totalCount', 11),

        // after TypeChanged(vacation) - still 11 for Alice in your fixture
        isA<AbsenceListState>().having((s) => s.totalCount, 'totalCount', 11),

        // after ClearFiltersRequested() - should reset all filters and pagination
        isA<AbsenceListState>()
            .having((s) => s.searchQuery, 'searchQuery', '')
            .having((s) => s.selectedType, 'selectedType', null)
            .having((s) => s.selectedStatus, 'selectedStatus', null)
            .having((s) => s.fromDate, 'fromDate', null)
            .having((s) => s.toDate, 'toDate', null)
            .having((s) => s.currentPage, 'currentPage', 0)
            .having((s) => s.totalCount, 'totalCount', 21)
            .having((s) => s.items.length, 'items.length', 10),
      ],
    );

    blocTest<AbsenceListBloc, AbsenceListState>(
      'paginates next and previous pages',
      build: () => AbsenceListBloc(repository),
      act: (bloc) async {
        bloc.add(LoadAbsences());
        await Future<void>.delayed(Duration.zero);
        bloc.add(NextPageRequested());
        bloc.add(NextPageRequested());
        bloc.add(PreviousPageRequested());
      },
      expect: () => <Matcher>[
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AbsenceListState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.totalPages, 'totalPages', 3)
            .having((s) => s.currentPage, 'currentPage', 0)
            .having((s) => s.items.length, 'items.length', 10),
        isA<AbsenceListState>()
            .having((s) => s.currentPage, 'currentPage', 1)
            .having((s) => s.items.length, 'items.length', 10),
        isA<AbsenceListState>()
            .having((s) => s.currentPage, 'currentPage', 2)
            .having((s) => s.items.length, 'items.length', 1),
        isA<AbsenceListState>()
            .having((s) => s.currentPage, 'currentPage', 1)
            .having((s) => s.items.length, 'items.length', 10),
      ],
    );

    blocTest<AbsenceListBloc, AbsenceListState>(
      'resets to page 0 when filters change',
      build: () => AbsenceListBloc(repository),
      act: (bloc) async {
        bloc.add(LoadAbsences());
        await Future<void>.delayed(Duration.zero);
        bloc.add(NextPageRequested());
        bloc.add(NextPageRequested());
        bloc.add(SearchChanged('bob'));
      },
      expect: () => <Matcher>[
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AbsenceListState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.currentPage, 'currentPage', 0),
        isA<AbsenceListState>().having((s) => s.currentPage, 'currentPage', 1),
        isA<AbsenceListState>().having((s) => s.currentPage, 'currentPage', 2),
        isA<AbsenceListState>()
            .having((s) => s.currentPage, 'currentPage', 0)
            .having((s) => s.totalCount, 'totalCount', 7),
      ],
    );

    blocTest<AbsenceListBloc, AbsenceListState>(
      'emits error state when repository throws',
      build: () => AbsenceListBloc(
        FakeAbsenceRepository(
          absences: const [],
          members: const [],
          throwOnLoad: true,
        ),
      ),
      act: (bloc) => bloc.add(LoadAbsences()),
      expect: () => <Matcher>[
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AbsenceListState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.hasError, 'hasError', true),
      ],
    );

    blocTest<AbsenceListBloc, AbsenceListState>(
      'filters by date range (inclusive)',
      build: () => AbsenceListBloc(repository),
      act: (bloc) async {
        bloc.add(LoadAbsences());
        await bloc.stream.firstWhere((s) => !s.isLoading && !s.hasError);

        bloc.add(FromDateChanged(DateTime(2025, 1, 1)));
        bloc.add(ToDateChanged(DateTime(2025, 1, 2)));
      },
      expect: () => <Matcher>[
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', false),
        isA<AbsenceListState>().having(
          (s) => s.fromDate,
          'fromDate',
          DateTime(2025, 1, 1),
        ),
        isA<AbsenceListState>().having(
          (s) => s.toDate,
          'toDate',
          DateTime(2025, 1, 2),
        ),
      ],
    );

    blocTest<AbsenceListBloc, AbsenceListState>(
      'auto-adjusts toDate when fromDate is after toDate',
      build: () => AbsenceListBloc(repository),
      act: (bloc) async {
        bloc.add(LoadAbsences());
        await bloc.stream.firstWhere((s) => !s.isLoading && !s.hasError);

        bloc.add(ToDateChanged(DateTime(2025, 1, 5)));
        bloc.add(FromDateChanged(DateTime(2025, 1, 10)));
      },
      expect: () => <Matcher>[
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', false),
        isA<AbsenceListState>().having(
          (s) => s.toDate,
          'toDate',
          DateTime(2025, 1, 5),
        ),
        isA<AbsenceListState>()
            .having((s) => s.fromDate, 'fromDate', DateTime(2025, 1, 10))
            .having((s) => s.toDate, 'toDate', DateTime(2025, 1, 10)),
      ],
    );

    blocTest(
      'auto-adjusts fromDate when toDate is before fromDate',
      build: () => AbsenceListBloc(repository),
      act: (bloc) async {
        bloc.add(LoadAbsences());
        await bloc.stream.firstWhere((s) => !s.isLoading && !s.hasError);

        bloc.add(FromDateChanged(DateTime(2025, 1, 12)));
        bloc.add(ToDateChanged(DateTime(2025, 1, 5)));
      },
      expect: () => <Matcher>[
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AbsenceListState>().having((s) => s.isLoading, 'isLoading', false),
        isA<AbsenceListState>().having(
          (s) => s.fromDate,
          'fromDate',
          DateTime(2025, 1, 12),
        ),
        isA<AbsenceListState>()
            .having((s) => s.fromDate, 'fromDate', DateTime(2025, 1, 5))
            .having((s) => s.toDate, 'toDate', DateTime(2025, 1, 5)),
      ],
    );
  });
}

// Helper function to generate absences for testing
List<Absence> _buildAbsencesForUser({
  required int userId,
  required int crewId,
  required int count,
  required AbsenceType type,
  required AbsenceStatus status,
}) {
  return List<Absence>.generate(count, (i) {
    final start = DateTime(2025, 1, 1).add(Duration(days: i * 2));
    final end = start.add(const Duration(days: 1));

    DateTime? confirmedAt;
    DateTime? rejectedAt;

    if (status == AbsenceStatus.confirmed) confirmedAt = DateTime(2024, 12, 1);
    if (status == AbsenceStatus.rejected) rejectedAt = DateTime(2024, 12, 1);

    return Absence(
      id: (userId * 1000) + i,
      crewId: crewId,
      userId: userId,
      type: type,
      startDate: start,
      endDate: end,
      createdAt: DateTime(2024, 11, 1),
      confirmedAt: confirmedAt,
      rejectedAt: rejectedAt,
      memberNote: i.isEven ? 'Note $i' : null,
      admitterNote: i.isOdd ? 'Admin $i' : null,
    );
  });
}
