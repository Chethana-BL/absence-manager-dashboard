import 'package:absence_manager_dashboard/features/absence_management/data/datasources/absence_remote_data_source.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/models/absence_model.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/models/member_model.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  late MockHttpClient client;
  late AbsenceRemoteDataSourceImpl dataSource;

  setUp(() {
    client = MockHttpClient();
    dataSource = AbsenceRemoteDataSourceImpl(client: client);
  });

  group('getAbsences', () {
    test('parses absence JSON array', () async {
      final json = '''
      [
        {
          "admitterId": null,
          "admitterNote": "",
          "confirmedAt": "2024-12-12T18:03:55.000+01:00",
          "createdAt": "2024-12-12T14:17:01.000+01:00",
          "crewId": 352,
          "endDate": "2026-01-13",
          "id": 2351,
          "memberNote": "",
          "rejectedAt": null,
          "startDate": "2026-01-13",
          "type": "sickness",
          "userId": 2664
        }
      ]
      ''';

      when(
        () => client.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response(json, 200));

      // Act
      final result = await dataSource.getAbsences();

      // Assert
      expect(result, isA<List<AbsenceModel>>());
      expect(result, hasLength(1));

      final first = result.first;

      // These should match your model structure; adjust if needed:
      expect(first.id, 2351);
      expect(first.userId, 2664);
      expect(first.crewId, 352);
      expect(first.type, AbsenceType.sickness);
    });

    test('throws on non-200 status code', () async {
      when(
        () => client.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('{"error":"nope"}', 500));

      expect(() => dataSource.getAbsences(), throwsException);
    });

    test('throws on invalid JSON', () async {
      when(
        () => client.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('not-json', 200));

      expect(() => dataSource.getAbsences(), throwsException);
    });

    test('throws when response is not a JSON array', () async {
      when(
        () => client.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('{"payload":[]}', 200));

      expect(() => dataSource.getAbsences(), throwsException);
    });

    test('throws TimeoutException as a user-friendly exception', () async {
      when(() => client.get(any(), headers: any(named: 'headers'))).thenAnswer((
        _,
      ) async {
        // Simulate call taking too long; your datasource uses .timeout(...)
        await Future<void>.delayed(const Duration(seconds: 15));
        return http.Response('[]', 200);
      });

      // Because datasource uses timeout(8s), this should throw
      expect(() => dataSource.getAbsences(), throwsException);
    });
  });

  group('getMembers', () {
    test('parses real members JSON array (happy path)', () async {
      final json = '''
      [
        {
          "crewId": 352,
          "id": 709,
          "image": "https://loremflickr.com/300/400",
          "name": "Max",
          "userId": 644
        },
        {
          "crewId": 352,
          "id": 713,
          "image": "https://loremflickr.com/300/400",
          "name": "Ines",
          "userId": 649
        }
      ]
      ''';

      when(
        () => client.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response(json, 200));

      final result = await dataSource.getMembers();

      expect(result, isA<List<MemberModel>>());
      expect(result, hasLength(2));

      expect(result[0].id, 709);
      expect(result[0].name, 'Max');
      expect(result[0].userId, 644);

      expect(result[1].id, 713);
      expect(result[1].name, 'Ines');
      expect(result[1].userId, 649);
    });

    test('throws when response is not a JSON array', () async {
      when(
        () => client.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('{"members":[]}', 200));

      expect(() => dataSource.getMembers(), throwsException);
    });

    test('throws on network client exception', () async {
      when(
        () => client.get(any(), headers: any(named: 'headers')),
      ).thenThrow(http.ClientException('No Internet'));

      expect(() => dataSource.getMembers(), throwsException);
    });
  });
}
