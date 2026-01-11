import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../services/quiz_service.dart';
import 'quiz_list_screen_with_lesson.dart';

class LessonSelectionScreen extends StatelessWidget {
  final Subject subject;

  const LessonSelectionScreen({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${subject.name} - Lessons'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: subject.lessons.length,
        itemBuilder: (context, index) {
          final lesson = subject.lessons[index];
          return _LessonCard(
            lesson: lesson,
            subjectColor: subject.color,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizListScreenWithLesson(
                    lesson: lesson,
                    subjectName: subject.name,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  final String subjectColor;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lesson,
    required this.subjectColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(
                color: Color(int.parse(subjectColor)),
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lesson.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(int.parse(subjectColor))
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${lesson.quizzesCount} quizzes',
                          style: TextStyle(
                            color: Color(int.parse(subjectColor)),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(int.parse(subjectColor)),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
