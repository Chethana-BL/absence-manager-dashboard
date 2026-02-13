import 'dart:convert';

import 'package:absence_manager_dashboard/features/absence_management/data/datasources/absence_data_source.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/models/absence_model.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/models/api_response.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/models/member_model.dart';
import 'package:flutter/services.dart';

class AbsenceLocalDataSourceImpl implements AbsenceDataSource {
  const AbsenceLocalDataSourceImpl();

  static const String _absencesPath = 'assets/mock/absences.json';
  static const String _membersPath = 'assets/mock/members.json';

  @override
  Future<List<AbsenceModel>> getAbsences() async {
    final jsonString = await rootBundle.loadString(_absencesPath);
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    final response = ApiResponse.fromJsonMap(jsonMap);

    return response.payload
        .map(
          (dynamic item) => AbsenceModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<MemberModel>> getMembers() async {
    final jsonString = await rootBundle.loadString(_membersPath);
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    final response = ApiResponse.fromJsonMap(jsonMap);

    return response.payload
        .map(
          (dynamic item) => MemberModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}
