import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';

class ResultsScreen extends StatelessWidget {
  final Quiz quiz;
  final QuizResult result;

  const ResultsScreen({
    super.key,
    required this.quiz,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = result.percentageScore;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Results'),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Your Score',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: percentage >= 70
                              ? Colors.green.shade100
                              : percentage >= 50
                                  ? Colors.orange.shade100
                                  : Colors.red.shade100,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall,
                              ),
                              Text(
                                '${result.score}/${result.totalQuestions}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
             ElevatedButton(
  onPressed: () {
    final userId = context.read<AuthProvider>().currentUser?.uid;

    if (userId != null) {
      context.read<QuizProvider>().fetchUserStatistics(userId);
      context.read<QuizProvider>().fetchUserResults(userId);
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',   // your Home route
      (route) => false, // removes all previous screens
    );
  },
  child: const Text('Back to Home'),
),

            ],
          ),
        ),
      ),
    );
  }
}
