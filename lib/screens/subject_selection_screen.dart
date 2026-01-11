import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../services/quiz_service.dart';
import 'lesson_selection_screen.dart';

class SubjectSelectionScreen extends StatelessWidget {
  const SubjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizService = QuizService();
    final subjects = quizService.getAllSubjects();

    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Select a subject to start learning"),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return _SubjectCard(
              subject: subject,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonSelectionScreen(
                      subject: subject,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.subject,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Color(int.parse(subject.color)),
                Color(int.parse(subject.color)).withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIcon(subject.icon),
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                subject.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '${subject.lessons.length} lessons',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'biology':
        return Icons.favorite;
      case 'chemistry':
        return Icons.bubble_chart;
      case 'physics':
        return Icons.bolt;
      default:
        return Icons.school;
    }
  }
}
