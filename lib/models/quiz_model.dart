class Question {
  final String id;
  final String category;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final String? image;

  Question({
    required this.id,
    required this.category,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.image,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] as String,
        category: json['category'] as String,
        question: json['question'] as String,
        options: List<String>.from(json['options'] as List),
        correctAnswer: json['correctAnswer'] as int,
        explanation: json['explanation'] as String,
        image: json['image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'question': question,
        'options': options,
        'correctAnswer': correctAnswer,
        'explanation': explanation,
        'image': image,
      };
}

class Quiz {
  final String id;
  final String title;
  final String category;
  final String description;
  final String? lessonId;
  final List<Question> questions;
  final int difficulty;
  final Duration timeLimit;

  Quiz({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    this.lessonId,
    required this.questions,
    required this.difficulty,
    required this.timeLimit,
  });
}

class QuizResult {
  final String quizId;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;
  final List<int> selectedAnswers;

  QuizResult({
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
    required this.selectedAnswers,
  });

  double get percentage => (score / totalQuestions) * 100;
}
