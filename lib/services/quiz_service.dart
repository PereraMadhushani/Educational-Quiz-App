import '../models/quiz_model.dart';

class QuizService {
  // Mock data for quizzes
  static final List<Quiz> _quizzes = [
    Quiz(
      id: '1',
      title: 'Physics Basics',
      category: 'Physics',
      description: 'Test your knowledge of fundamental physics concepts',
      questions: _getPhysicsQuestions(),
      difficulty: 1,
      timeLimit: const Duration(minutes: 15),
    ),
    Quiz(
      id: '2',
      title: 'Chemistry Elements',
      category: 'Chemistry',
      description: 'Explore the periodic table and chemical reactions',
      questions: _getChemistryQuestions(),
      difficulty: 2,
      timeLimit: const Duration(minutes: 20),
    ),
  ];

  Future<List<Quiz>> getAllQuizzes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _quizzes;
  }

  Future<Quiz?> getQuizById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _quizzes.firstWhere((quiz) => quiz.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveQuizResult(QuizResult result) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Save result to database
  }

  static List<Question> _getPhysicsQuestions() => [
        Question(
          id: '1',
          category: 'Physics',
          question: 'What is the SI unit of force?',
          options: ['Joule', 'Newton', 'Pascal', 'Watt'],
          correctAnswer: 1,
          explanation: 'Newton (N) is the SI unit of force. 1 N = 1 kg·m/s²',
        ),
      ];

  static List<Question> _getChemistryQuestions() => [
        Question(
          id: '1',
          category: 'Chemistry',
          question: 'What is the chemical formula for table salt?',
          options: ['KCl', 'NaCl', 'CaCl2', 'MgCl2'],
          correctAnswer: 1,
          explanation: 'NaCl is sodium chloride, commonly known as table salt.',
        ),
      ];
}
