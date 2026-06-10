import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:bnu_lms_app/shared/config/api_constants.dart';
import 'dart:async';

@singleton
class SignalRService {
  HubConnection? _assignmentHubConnection;
  HubConnection? _forumHubConnection;
  HubConnection? _quizHubConnection;
  HubConnection? _gradeHubConnection;

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

  Stream<Map<String, dynamic>> get assignmentStream => _assignmentController.stream;
  Stream<int> get submissionGradedStream => _submissionGradedController.stream;

  Stream<Map<String, dynamic>> get newDiscussionStream => _newDiscussionController.stream;
  Stream<Map<String, dynamic>> get newPostStream => _newPostController.stream;
  Stream<Map<String, dynamic>> get voteUpdateStream => _voteUpdateController.stream;
  Stream<Map<String, dynamic>> get correctAnswerStream => _correctAnswerController.stream;

  Stream<Map<String, dynamic>> get quizStream => _newQuizController.stream;
  Stream<Map<String, dynamic>> get gradeUpdateStream => _gradeUpdateController.stream;

  Future<void> init(String token) async {
    final options = HttpConnectionOptions(accessTokenFactory: () async => token);

    // 1. Assignment Hub
    if (_assignmentHubConnection == null) {
      final assignmentUrl = ApiConstants.hubUrl('assignmentHub');
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

      await _assignmentHubConnection!.start();
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
      } catch (e) {
        print('❌ GRADE SIGNALR: Connection Failed! Error: $e');
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
  }
}