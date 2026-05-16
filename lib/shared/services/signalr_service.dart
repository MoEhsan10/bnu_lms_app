import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:bnu_lms_app/shared/config/api_constants.dart';
import 'dart:async';

@singleton
class SignalRService {
  HubConnection? _hubConnection;
  final _assignmentController = StreamController<Map<String, dynamic>>.broadcast();
  final _submissionGradedController = StreamController<int>.broadcast();

  Stream<Map<String, dynamic>> get assignmentStream => _assignmentController.stream;
  Stream<int> get submissionGradedStream => _submissionGradedController.stream;

  Future<void> init(String token) async {
    if (_hubConnection != null) return;

    // The backend SignalR hub URL
    final hubUrl = '${ApiConstants.baseUrl.replaceAll('/api', '')}/assignmentHub';

    _hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token,
            ))
        .withAutomaticReconnect()
        .build();

    _hubConnection!.on('NewAssignmentAdded', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        _assignmentController.add(arguments[0] as Map<String, dynamic>);
      }
    });

    _hubConnection!.on('SubmissionGraded', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments[0] as Map<String, dynamic>;
        if (data.containsKey('AssignmentId')) {
          _submissionGradedController.add(data['AssignmentId'] as int);
        } else if (data.containsKey('assignmentId')) {
          _submissionGradedController.add(data['assignmentId'] as int);
        }
      }
    });

    await _hubConnection!.start();
  }

  Future<void> joinCourse(int courseId) async {
    if (_hubConnection?.state == HubConnectionState.Connected) {
      await _hubConnection!.invoke('JoinCourseGroup', args: [courseId.toString()]);
    }
  }

  Future<void> leaveCourse(int courseId) async {
    if (_hubConnection?.state == HubConnectionState.Connected) {
      await _hubConnection!.invoke('LeaveCourseGroup', args: [courseId.toString()]);
    }
  }

  void dispose() {
    _hubConnection?.stop();
    _assignmentController.close();
    _submissionGradedController.close();
  }
}
