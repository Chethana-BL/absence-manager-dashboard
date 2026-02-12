import 'dart:convert';
import 'dart:io';

import 'package:absence_manager_dashboard/core/services/ical_export/ical_export_service.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/view_models/absence_list_item_vm.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ICalExportServiceMobile extends ICalExportService {
  ICalExportServiceMobile();

  @override
  Future<void> export(List<AbsenceListItemVm> items) async {
    if (items.isEmpty) return;

    final content = buildIcsContent(items);

    final dir = await getTemporaryDirectory();
    final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${dir.path}/absences_$ts.ics');

    await file.writeAsBytes(utf8.encode(content), flush: true);

    await SharePlus.instance.share(
      ShareParams(
        title: 'Absence Calendar',
        text: 'Here are your absences in iCal format.',
        files: [XFile(file.path)],
      ),
    );
  }
}

ICalExportService createICalExportService() => ICalExportServiceMobile();
