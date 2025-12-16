import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/providers/theme_provider.dart';
import '../widgets/fourms_details/forum_answer_card.dart';
import '../widgets/fourms_details/forum_answer_input.dart';
import '../widgets/fourms_details/forum_question_card.dart';


class ForumsDetailsScreen extends StatefulWidget {
  final String forumTitle;

  const ForumsDetailsScreen({
    required this.forumTitle,
    super.key,
  });

  @override
  State<ForumsDetailsScreen> createState() => _ForumsDetailsScreenState();
}

class _ForumsDetailsScreenState extends State<ForumsDetailsScreen> {
  final TextEditingController answerController = TextEditingController();

  // Static data for UI demonstration
  final Map<String, dynamic> forumQuestion = {
    'author': 'Dr. Ahmed Hassan',
    'authorRole': 'Started 3w ago',
    'title': 'The Impact of AI on Education',
    'question':
    'Let\'s discuss the transformative impact of AI on education. How do you think AI will change teaching and learning at BNU?',
    'votes': 12,
  };

  final List<Map<String, dynamic>> answers = [
    {
      'author': 'Layla Ibrahim',
      'timestamp': 'Answered 1w ago',
      'answer':
      'AI can automate administrative tasks, freeing up educators\' time to focus on teaching and student interaction.',
      'votes': 10,
      'isTopRated': true,
    },
    {
      'author': 'Fatima Ali',
      'timestamp': 'Answered 5d ago',
      'answer':
      'AI can personalize learning, providing tailored content and feedback to each student. This could significantly improve learning outcomes.',
      'votes': 8,
      'isTopRated': false,
    },
    {
      'author': 'Youssef Mahmoud',
      'timestamp': 'Answered 1d ago',
      'answer':
      'We need to consider the digital literacy of both students and teachers. Training and support will be crucial for successful AI integration.',
      'votes': 7,
      'isTopRated': false,
    },
    {
      'author': 'Omar Khaled',
      'timestamp': 'Answered 1d ago',
      'answer':
      'I\'m concerned about the ethical implications. How do we ensure AI is used responsibly and doesn\'t exacerbate existing inequalities?',
      'votes': 6,
      'isTopRated': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      backgroundColor: isLight
          ? ColorsManager.lightBackground
          : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor:
        isLight ? ColorsManager.white : ColorsManager.darkSurface,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isLight
                ? ColorsManager.black
                : ColorsManager.darkTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Forum Discussion',
          style: isLight
              ? AppLightTextStyles.headlineLarge
              : AppDarkTextStyles.headlineLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: isLight
                  ? ColorsManager.black
                  : ColorsManager.darkTextPrimary,
            ),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ForumQuestionCard(
                    authorName: forumQuestion['author'],
                    authorRole: forumQuestion['authorRole'],
                    questionTitle: forumQuestion['title'],
                    questionBody: forumQuestion['question'],
                    votes: forumQuestion['votes'],
                  ),
                  _buildAnswersHeader(isLight),
                  _buildAnswersList(isLight),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
          ForumAnswerInput(
            controller: answerController,
            onSubmit: () {
              // Handle submit
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnswersHeader(bool isLight) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Text(
            '${answers.length} Answers',
            style: isLight
                ? AppLightTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsManager.black,
            )
                : AppDarkTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsManager.darkTextPrimary,
            ),
          ),
          Spacer(),
          Text(
            'Sorted by: ',
            style: TextStyle(
              fontSize: 13,
              color: isLight
                  ? ColorsManager.grayMedium
                  : ColorsManager.darkTextSecondary,
            ),
          ),
          Text(
            'Highest score',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isLight
                  ? ColorsManager.black
                  : ColorsManager.darkTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswersList(bool isLight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: answers.map((answer) {
          return ForumAnswerCard(
            authorName: answer['author'],
            timestamp: answer['timestamp'],
            answerText: answer['answer'],
            votes: answer['votes'],
            isTopRated: answer['isTopRated'],
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }
}