import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/quiz_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.appName),
          backgroundColor: AppColors.primaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.homeTitle,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Test your science knowledge with our engaging quizzes',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Featured Quizzes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildQuizzesList(),
              ],
            ),
          ),
        ),
      );

  Widget _buildQuizzesList() => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => QuizCard(
          title: _getQuizTitle(index),
          category: _getCategory(index),
          questionCount: 10 + (index * 5),
          difficulty: (index % 3) + 1,
          onTap: () => _startQuiz(index),
        ),
      );

  String _getQuizTitle(int index) {
    final titles = [
      'Physics Basics',
      'Chemistry Elements',
      'Biology Fundamentals',
      'General Science',
    ];
    return titles[index];
  }

  String _getCategory(int index) {
    final categories = [
      AppStrings.physics,
      AppStrings.chemistry,
      AppStrings.biology,
      AppStrings.generalScience,
    ];
    return categories[index];
  }

  void _startQuiz(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting quiz: ${_getQuizTitle(index)}')),
    );
  }
}
