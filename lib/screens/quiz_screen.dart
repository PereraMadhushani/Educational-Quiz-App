import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import 'results_screen.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizScreen({super.key, required this.quiz});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late PageController _pageController;
  int _currentQuestion = 0;
  List<int?> _userAnswers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userAnswers = List<int?>.filled(widget.quiz.questions.length, null);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _submitQuiz(BuildContext context) {
    // Count unanswered questions
    int unansweredCount = 0;
    for (int i = 0; i < _userAnswers.length; i++) {
      if (_userAnswers[i] == null) {
        unansweredCount++;
      }
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to submit this quiz?'),
            if (unansweredCount > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$unansweredCount question(s) not answered',
                        style: TextStyle(color: Colors.orange.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performSubmit(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _performSubmit(BuildContext context) {
    // Calculate score
    int score = 0;
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      if (_userAnswers[i] == widget.quiz.questions[i].correctAnswerIndex) {
        score++;
      }
    }

    // Create QuizResult
    final userId = context.read<AuthProvider>().currentUser?.uid ?? '';
    final result = QuizResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      quizId: widget.quiz.id,
      quizTitle: widget.quiz.title,
      score: score,
      totalQuestions: widget.quiz.questions.length,
      userAnswers: _userAnswers.cast<int>(),
      timeSpent: 0,
      completedAt: DateTime.now(),
    );

    // Save result to database
    context.read<QuizProvider>().submitQuizResult(result);

    // Navigate to results screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(quiz: widget.quiz, result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
      ),
      body: widget.quiz.questions.isEmpty
          ? const Center(child: Text('No questions available'))
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentQuestion = index);
                    },
                    itemCount: widget.quiz.questions.length,
                    itemBuilder: (context, index) {
                      final question = widget.quiz.questions[index];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${index + 1}/${widget.quiz.questions.length}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              question.questionText,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 24),
                            ...List.generate(
                              question.options.length,
                              (optionIndex) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _userAnswers[index] = optionIndex;
                                  });
                                },
                                child: Card(
                                  color: _userAnswers[index] == optionIndex
                                      ? Colors.blue.shade100
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Radio<int?>(
                                          value: optionIndex,
                                          groupValue: _userAnswers[index],
                                          onChanged: (value) {
                                            setState(() {
                                              _userAnswers[index] = value;
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: Text(question.options[optionIndex]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentQuestion > 0)
                        ElevatedButton(
                          onPressed: () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          child: const Text('Previous'),
                        )
                      else
                        const SizedBox(),
                      if (_currentQuestion < widget.quiz.questions.length - 1)
                        ElevatedButton(
                          onPressed: () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          child: const Text('Next'),
                        )
                      else
                        ElevatedButton(
                          onPressed: () {
                            _submitQuiz(context);
                          },
                          child: const Text('Submit'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
