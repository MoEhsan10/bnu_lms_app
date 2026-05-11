import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:bnu_lms_app/shared/config/api_constants.dart';
import 'dart:async';

@singleton
class SignalRService {
  HubConnection? _hubConnection;
  final _assignmentController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get assignmentStream => _assignmentController.stream;

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
  }
}
