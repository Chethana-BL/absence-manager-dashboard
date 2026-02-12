import 'dart:convert';

import 'package:absence_manager_dashboard/core/services/ical_export/ical_export_service.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/view_models/absence_list_item_vm.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

class ICalExportServiceWeb extends ICalExportService {
  ICalExportServiceWeb();

  @override
  Future<void> export(List<AbsenceListItemVm> items) async {
    if (items.isEmpty) return;

    final content = buildIcsContent(items);

    final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'absences_$ts.ics';

    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes], 'text/calendar;charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final a = html.AnchorElement(href: url)
      ..download = fileName
      ..style.display = 'none';

    html.document.body?.append(a);
    a.click();
    a.remove();

    html.Url.revokeObjectUrl(url);
  }
}

ICalExportService createICalExportService() => ICalExportServiceWeb();
