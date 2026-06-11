import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:bnu_lms_app/shared/config/api_constants.dart';
import 'dart:async';
import 'dart:convert';

@singleton
class SignalRService {
  HubConnection? _assignmentHubConnection;
  HubConnection? _forumHubConnection;
  HubConnection? _quizHubConnection;
  HubConnection? _gradeHubConnection;
  HubConnection? _notificationHubConnection;

  // Assignments Streams
  final _assignmentController = StreamController<Map<String, dynamic>>.broadcast();
  final _submissionGradedController = StreamController<int>.broadcast();

  // Forums Streams
  final _newDiscussionController = StreamController<Map<String, dynamic>>.broadcast();
  final _newPostController = StreamController<Map<String, dynamic>>.broadcast();
  final _voteUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  final _correctAnswerController = StreamController<Map<String, dynamic>>.broadcast();

  // Quizzes Streams
  final _newQuizController = StreamController<Map<String, dynamic>>.broadcast();

  // Grades Streams
  final _gradeUpdateController = StreamController<Map<String, dynamic>>.broadcast();

  // Notifications Streams
  final _newNotificationController = StreamController<Map<String, dynamic>>.broadcast();
  final _announcementUpdatedController = StreamController<Map<String, dynamic>>.broadcast();
  final _announcementDeletedController = StreamController<int>.broadcast();

  Stream<Map<String, dynamic>> get assignmentStream => _assignmentController.stream;
  Stream<int> get submissionGradedStream => _submissionGradedController.stream;

  Stream<Map<String, dynamic>> get newDiscussionStream => _newDiscussionController.stream;
  Stream<Map<String, dynamic>> get newPostStream => _newPostController.stream;
  Stream<Map<String, dynamic>> get voteUpdateStream => _voteUpdateController.stream;
  Stream<Map<String, dynamic>> get correctAnswerStream => _correctAnswerController.stream;

  Stream<Map<String, dynamic>> get quizStream => _newQuizController.stream;
  Stream<Map<String, dynamic>> get gradeUpdateStream => _gradeUpdateController.stream;
  Stream<Map<String, dynamic>> get newNotificationStream => _newNotificationController.stream;
  Stream<Map<String, dynamic>> get announcementUpdatedStream => _announcementUpdatedController.stream;
  Stream<int> get announcementDeletedStream => _announcementDeletedController.stream;

  Future<void> init(String token) async {
    final options = HttpConnectionOptions(accessTokenFactory: () async => token);

    // Extract userId from JWT token claims (sub claim)
    String? userId;
    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = parts[1];
        final normalized = base64Url.normalize(payload);
        final decoded = utf8.decode(base64Url.decode(normalized));
        final Map<String, dynamic> claims = json.decode(decoded);
        userId = claims['sub'] as String? ??
                  claims['nameid'] as String? ??
                  claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] as String?;
        print('🔑 SIGNALR: Extracted userId from JWT: $userId');
      }
    } catch (e) {
      print('⚠️ SIGNALR: Could not parse userId from JWT: $e');
    }

    // 1. Assignment Hub
    if (_assignmentHubConnection == null) {
      final assignmentUrl = ApiConstants.hubUrl('assignmentHub');
      print('🌐 ASSIGNMENT SIGNALR: Attempting to connect to $assignmentUrl');
      _assignmentHubConnection = HubConnectionBuilder()
          .withUrl(assignmentUrl, options: options)
          .withAutomaticReconnect()
          .build();

      _assignmentHubConnection!.on('NewAssignmentAdded', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          _assignmentController.add(arguments[0] as Map<String, dynamic>);
        }
      });

      _assignmentHubConnection!.on('SubmissionGraded', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          final data = arguments[0] as Map<String, dynamic>;
          if (data.containsKey('AssignmentId')) {
            _submissionGradedController.add(data['AssignmentId'] as int);
          } else if (data.containsKey('assignmentId')) {
            _submissionGradedController.add(data['assignmentId'] as int);
          }
        }
      });

      try {
        await _assignmentHubConnection!.start();
        print('✅ ASSIGNMENT SIGNALR: Connected Successfully!');
      } catch (e) {
        print('❌ ASSIGNMENT SIGNALR: Connection Failed! Error: $e');
      }
    }

    // 2. Forum Hub
    if (_forumHubConnection == null) {
      final forumUrl = ApiConstants.hubUrl('forumHub');
      print('🌐 FORUMS SIGNALR: Attempting to connect to $forumUrl');

      _forumHubConnection = HubConnectionBuilder()
          .withUrl(forumUrl, options: options)
          .withAutomaticReconnect()
          .build();

      _forumHubConnection!.on('ReceiveNewDiscussion', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            print('🔥 FORUMS SIGNALR: Received New Discussion -> ${arguments.first}');
            _newDiscussionController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch(e) { print('❌ FORUMS PARSE ERROR (Discussion): $e'); }
        }
      });

      _forumHubConnection!.on('ReceiveNewPost', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            print('🔥 FORUMS SIGNALR: Received New Post -> ${arguments.first}');
            _newPostController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch(e) { print('❌ FORUMS PARSE ERROR (Post): $e'); }
        }
      });

      _forumHubConnection!.on('ReceiveVoteUpdate', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            print('🔥 FORUMS SIGNALR: Received Vote Update -> ${arguments.first}');
            _voteUpdateController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch(e) { print('❌ FORUMS PARSE ERROR (Vote): $e'); }
        }
      });

      _forumHubConnection!.on('ReceiveCorrectAnswer', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            print('🔥 FORUMS SIGNALR: Received Correct Answer -> ${arguments.first}');
            _correctAnswerController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch(e) { print('❌ FORUMS PARSE ERROR (CorrectAnswer): $e'); }
        }
      });

      try {
        await _forumHubConnection!.start();
        print('✅ FORUMS SIGNALR: Connected Successfully!');
      } catch (e) {
        print('❌ FORUMS SIGNALR: Connection Failed! Error: $e');
      }
    }

    // 3. Quiz Hub
    if (_quizHubConnection == null) {
      final quizUrl = ApiConstants.hubUrl('quizHub');
      print('🌐 QUIZ SIGNALR: Attempting to connect to $quizUrl');

      _quizHubConnection = HubConnectionBuilder()
          .withUrl(quizUrl, options: options)
          .withAutomaticReconnect()
          .build();

      _quizHubConnection!.on('ReceiveNewQuiz', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            print('🔥 QUIZ SIGNALR: Received New Quiz -> ${arguments.first}');
            _newQuizController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch (e) {
            print('❌ QUIZ PARSE ERROR: $e');
          }
        }
      });

      try {
        await _quizHubConnection!.start();
        print('✅ QUIZ SIGNALR: Connected Successfully!');
      } catch (e) {
        print('❌ QUIZ SIGNALR: Connection Failed! Error: $e');
      }
    }

    // 4. Grade Hub
    if (_gradeHubConnection == null) {
      final gradeUrl = ApiConstants.hubUrl('gradeHub');
      print('🌐 GRADE SIGNALR: Attempting to connect to $gradeUrl');
      
      _gradeHubConnection = HubConnectionBuilder()
          .withUrl(gradeUrl, options: options)
          .withAutomaticReconnect()
          .build();

      _gradeHubConnection!.on('ReceiveGradeUpdate', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            _gradeUpdateController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch (e) {
            print('❌ GRADE PARSE ERROR: $e');
          }
        }
      });

      _gradeHubConnection!.on('TermWorkPublished', (arguments) {
        _gradeUpdateController.add({"event": "TermWorkPublished"});
      });

      _gradeHubConnection!.on('TermWorkUnlocked', (arguments) {
        _gradeUpdateController.add({"event": "TermWorkUnlocked"});
      });

      try {
        await _gradeHubConnection!.start();
        print('✅ GRADE SIGNALR: Connected Successfully!');
      } catch (e) {
        print('❌ GRADE SIGNALR: Connection Failed! Error: $e');
      }
    }

    // 5. Notification Hub
    if (_notificationHubConnection == null) {
      final notificationUrl = ApiConstants.hubUrl('notificationHub');
      print('🌐 NOTIFICATION SIGNALR: Attempting to connect to $notificationUrl');
      
      _notificationHubConnection = HubConnectionBuilder()
          .withUrl(notificationUrl, options: options)
          .withAutomaticReconnect()
          .build();

      _notificationHubConnection!.on('ReceiveNotification', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            print('🔔 NOTIFICATION SIGNALR: Received event! Payload: ${arguments.first}');
            _newNotificationController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch (e) {
            print('❌ NOTIFICATION PARSE ERROR: $e');
          }
        }
      });

      _notificationHubConnection!.on('AnnouncementUpdated', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            print('🔔 NOTIFICATION SIGNALR: Announcement Updated! Payload: ${arguments.first}');
            _announcementUpdatedController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch (e) {
            print('❌ ANNOUNCEMENT UPDATE PARSE ERROR: $e');
          }
        }
      });

      _notificationHubConnection!.on('AnnouncementDeleted', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            print('🔔 NOTIFICATION SIGNALR: Announcement Deleted! ID: ${arguments.first}');
            _announcementDeletedController.add(arguments.first as int);
          } catch (e) {
            print('❌ ANNOUNCEMENT DELETE PARSE ERROR: $e');
          }
        }
      });

      try {
        await _notificationHubConnection!.start();
        print('✅ NOTIFICATION SIGNALR: Connected Successfully!');
        // CRITICAL: Join the personal group so Clients.Group("User_{id}") reaches this client
        if (userId != null) {
          await _notificationHubConnection!.invoke('JoinPersonalGroup', args: [userId]);
          print('✅ NOTIFICATION SIGNALR: Joined personal group User_$userId');
        } else {
          print('⚠️ NOTIFICATION SIGNALR: Could not join personal group – userId is null!');
        }
      } catch (e) {
        print('❌ NOTIFICATION SIGNALR: Connection Failed! Error: $e');
      }
    }
  }

  Future<void> joinCourse(int courseId) async {
    print('🚀 SIGNALR: Attempting to join course groups for CourseID: $courseId');

    if (_assignmentHubConnection?.state == HubConnectionState.Connected) {
      await _assignmentHubConnection!.invoke('JoinCourseGroup', args: [courseId.toString()]);
      print('✅ ASSIGNMENTS SIGNALR: Joined group $courseId successfully.');
    } else {
      print('⚠️ ASSIGNMENTS SIGNALR: Could not join group. State is ${_assignmentHubConnection?.state}');
    }

    if (_forumHubConnection?.state == HubConnectionState.Connected) {
      await _forumHubConnection!.invoke('JoinCourseGroup', args: [courseId.toString()]);
      print('✅ FORUMS SIGNALR: Joined group $courseId successfully.');
    } else {
      print('❌ FORUMS SIGNALR: Could not join group $courseId! State is ${_forumHubConnection?.state}');
    }

    if (_quizHubConnection?.state == HubConnectionState.Connected) {
      await _quizHubConnection!.invoke('JoinCourseGroup', args: [courseId.toString()]);
      print('✅ QUIZ SIGNALR: Joined group $courseId successfully.');
    } else {
      print('❌ QUIZ SIGNALR: Could not join group $courseId! State is ${_quizHubConnection?.state}');
    }

    if (_gradeHubConnection?.state == HubConnectionState.Connected) {
      await _gradeHubConnection!.invoke('JoinCourseGroup', args: [courseId.toString()]);
    }
  }

  Future<void> leaveCourse(int courseId) async {
    if (_assignmentHubConnection?.state == HubConnectionState.Connected) {
      await _assignmentHubConnection!.invoke('LeaveCourseGroup', args: [courseId.toString()]);
    }
    if (_forumHubConnection?.state == HubConnectionState.Connected) {
      await _forumHubConnection!.invoke('LeaveCourseGroup', args: [courseId.toString()]);
    }
    if (_quizHubConnection?.state == HubConnectionState.Connected) {
      await _quizHubConnection!.invoke('LeaveCourseGroup', args: [courseId.toString()]);
    }
    if (_gradeHubConnection?.state == HubConnectionState.Connected) {
      await _gradeHubConnection!.invoke('LeaveCourseGroup', args: [courseId.toString()]);
    }
  }

  void dispose() {
    _assignmentHubConnection?.stop();
    _forumHubConnection?.stop();
    _assignmentController.close();
    _submissionGradedController.close();
    _newDiscussionController.close();
    _newPostController.close();
    _voteUpdateController.close();
    _correctAnswerController.close();
    _newQuizController.close();
    _gradeHubConnection?.stop();
    _gradeUpdateController.close();
    _notificationHubConnection?.stop();
    _newNotificationController.close();
    _announcementUpdatedController.close();
    _announcementDeletedController.close();
  }
}