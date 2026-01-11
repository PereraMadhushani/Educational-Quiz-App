import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/quiz.dart';
import '../services/quiz_service.dart';
import 'quiz_screen.dart';

class QuizListScreenWithLesson extends StatelessWidget {
  final Lesson lesson;
  final String subjectName;

  const QuizListScreenWithLesson({
    super.key,
    required this.lesson,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    final quizService = QuizService();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lesson.title),
            Text(
              subjectName,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Quiz>>(
        future: quizService.getQuizzesByLessonFromFirebase(lesson.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading quizzes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString()),
                ],
              ),
            );
          }

          final quizzes = snapshot.data ?? [];

          if (quizzes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No quizzes available',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: Icon(
                    Icons.school,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(quiz.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        quiz.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.question_mark,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${quiz.questions.length} questions',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${quiz.timeLimit} min',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(quiz: quiz),
                      ),
                    );
                  },
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
