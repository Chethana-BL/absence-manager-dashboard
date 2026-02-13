import 'dart:async';
import 'dart:convert';

import 'package:absence_manager_dashboard/app/config/app_config.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/datasources/absence_data_source.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/models/absence_model.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/models/member_model.dart';
import 'package:http/http.dart' as http;

class AbsenceRemoteDataSourceImpl implements AbsenceDataSource {
  AbsenceRemoteDataSourceImpl({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<List<AbsenceModel>> getAbsences() async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/absences');

    try {
      final res = await _client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 8));

      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception('GET /absences failed (${res.statusCode})');
      }

      final decoded = jsonDecode(res.body);
      if (decoded is! List) {
        throw Exception('Invalid /absences response: expected a JSON array');
      }

      return decoded
          .cast<Map<String, dynamic>>()
          .map(AbsenceModel.fromJson)
          .toList();
    } on TimeoutException {
      throw Exception('Request timed out');
    } on http.ClientException {
      throw Exception('Network error');
    }
  }

  @override
  Future<List<MemberModel>> getMembers() async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/members');

    try {
      final res = await _client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 8));

      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception('GET /members failed (${res.statusCode})');
      }

      final decoded = jsonDecode(res.body);
      if (decoded is! List) {
        throw Exception('Invalid /members response: expected a JSON array');
      }

      return decoded
          .cast<Map<String, dynamic>>()
          .map(MemberModel.fromJson)
          .toList();
    } on TimeoutException {
      throw Exception('Request timed out');
    } on http.ClientException {
      throw Exception('Network error');
    }
  }
}
