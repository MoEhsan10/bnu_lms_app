import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import '../../domain/repositories/attendance_repository.dart';
import 'student_attendance_state.dart';

@injectable
class StudentAttendanceCubit extends Cubit<StudentAttendanceState> {
  final AttendanceRepository _repository;

  StudentAttendanceCubit(this._repository) : super(const StudentAttendanceInitial());

  Future<void> markAttendance({
    required String qrToken,
  }) async {
    emit(const StudentAttendanceLoading(statusMessage: "Checking location permissions..."));

    try {
      // 1. Request permission via permission_handler
      final status = await Permission.location.request();
      if (!status.isGranted) {
        emit(const StudentAttendanceError("Location permission is required to mark attendance."));
        return;
      }

      // 2. Get GPS coordinates via location package
      emit(const StudentAttendanceLoading(statusMessage: "Retrieving coordinates..."));
      final locData = await loc.Location().getLocation();
      final double lat = locData.latitude ?? 0.0;
      final double lng = locData.longitude ?? 0.0;

      // 3. Get Device ID
      emit(const StudentAttendanceLoading(statusMessage: "Retrieving unique device identifier..."));
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String deviceId = "device-unidentified";

      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? "ios-unidentified";
      } else {
        deviceId = "desktop-or-web-client";
      }

      // 4. Mark Attendance on Server
      emit(const StudentAttendanceLoading(statusMessage: "Syncing with Server..."));
      final result = await _repository.markAttendance(
        token: qrToken,
        deviceId: deviceId,
        lat: lat,
        lng: lng,
      );

      result.fold(
        (failure) => emit(StudentAttendanceError(failure.message)),
        (success) => emit(const StudentAttendanceSuccess()),
      );
    } catch (e) {
      emit(StudentAttendanceError("Verification failed: ${e.toString()}"));
    }
  }

  Future<void> fetchDashboard(int courseId) async {
    emit(const StudentDashboardLoading());
    try {
      final result = await _repository.getCourseAttendanceReports(courseId);
      result.fold(
        (failure) => emit(StudentDashboardError(failure.message)),
        (reports) {
          int present = 0;
          int absent = 0;
          for (final r in reports) {
            for (final rec in r.attendanceRecords) {
              if (rec.isPresent) {
                present++;
              } else {
                absent++;
              }
            }
          }
          final total = present + absent;
          final rate = total > 0 ? (present / total) * 100.0 : 0.0;
          emit(StudentDashboardLoaded(
            reports: reports,
            presentCount: present,
            absentCount: absent,
            attendanceRate: rate,
          ));
        },
      );
    } catch (e) {
      emit(StudentDashboardError("Failed to load dashboard: ${e.toString()}"));
    }
  }
}
