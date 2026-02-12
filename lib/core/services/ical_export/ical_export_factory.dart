import 'package:absence_manager_dashboard/core/services/ical_export/ical_export_service.dart';
import 'package:absence_manager_dashboard/core/services/ical_export/ical_export_service_mobile.dart'
    if (dart.library.html) 'package:absence_manager_dashboard/core/services/ical_export/ical_export_service_web.dart'
    as impl;

ICalExportService createICalExportService() => impl.createICalExportService();
