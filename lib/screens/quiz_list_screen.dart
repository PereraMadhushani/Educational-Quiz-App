import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'quiz_screen.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  final List<String> _topics = [
    'All Quizzes',
    'Atomic Structure',
    'Chemical Bonding',
    'Reactions',
    'Acids & Bases',
    'Thermodynamics',
  ];

  String _selectedTopic = 'All Quizzes';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _topics
                  .map(
                    (topic) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(topic),
                        selected: _selectedTopic == topic,
                        onSelected: (selected) {
                          setState(() {
                            _selectedTopic = topic;
                          });
                          if (topic == 'All Quizzes') {
                            context.read<QuizProvider>().fetchAllQuizzes();
                          } else {
                            context
                                .read<QuizProvider>()
                                .fetchQuizzesByTopic(topic);
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Expanded(
          child: Consumer<QuizProvider>(
            builder: (context, quizProvider, _) {
              if (quizProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (quizProvider.quizzes.isEmpty) {
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
                itemCount: quizProvider.quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizProvider.quizzes[index];
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
                                '${quiz.totalQuestions} questions',
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
        ),
      ],
    );
  }
}
