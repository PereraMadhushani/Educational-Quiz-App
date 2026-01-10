class Quiz {
  final String id;
  final String title;
  final String description;
  final String topic; // e.g., "Atomic Structure", "Chemical Bonding"
  final int totalQuestions;
  final int timeLimit; // in minutes
  final List<Question> questions;
  final DateTime createdAt;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.topic,
    required this.totalQuestions,
    required this.timeLimit,
    required this.questions,
    required this.createdAt,
  });

  factory Quiz.fromMap(Map<String, dynamic> map, String id) {
    // Handle Firestore Timestamp
    DateTime createdAt = DateTime.now();
    if (map['createdAt'] != null) {
      final createdAtValue = map['createdAt'];
      if (createdAtValue is String) {
        createdAt = DateTime.parse(createdAtValue);
      } else if (createdAtValue.runtimeType.toString().contains('Timestamp')) {
        // Handle Firestore Timestamp
        createdAt = (createdAtValue.toDate() as DateTime);
      }
    }

    return Quiz(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      topic: map['topic'] ?? '',
      totalQuestions: map['totalQuestions'] ?? 0,
      timeLimit: map['timeLimit'] ?? 30,
      questions: (map['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromMap(q as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'topic': topic,
      'totalQuestions': totalQuestions,
      'timeLimit': timeLimit,
      'questions': questions.map((q) => q.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Question {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String? imageUrl;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.imageUrl,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? '',
      questionText: map['questionText'] ?? '',
      options: List<String>.from(map['options'] as List<dynamic>? ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
      explanation: map['explanation'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionText': questionText,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'imageUrl': imageUrl,
    };
  }
}

class QuizResult {
  final String id;
  final String userId;
  final String quizId;
  final String quizTitle;
  final int score;
  final int totalQuestions;
  final List<int> userAnswers;
  final int timeSpent; // in seconds
  final DateTime completedAt;

  QuizResult({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.quizTitle,
    required this.score,
    required this.totalQuestions,
    required this.userAnswers,
    required this.timeSpent,
    required this.completedAt,
  });

  double get percentageScore => (score / totalQuestions * 100);

  factory QuizResult.fromMap(Map<String, dynamic> map, String id) {
    // Handle Firestore Timestamp
    DateTime completedAt = DateTime.now();
    if (map['completedAt'] != null) {
      final completedAtValue = map['completedAt'];
      if (completedAtValue is String) {
        completedAt = DateTime.parse(completedAtValue);
      } else if (completedAtValue.runtimeType.toString().contains('Timestamp')) {
        // Handle Firestore Timestamp
        completedAt = (completedAtValue.toDate() as DateTime);
      }
    }

    return QuizResult(
      id: id,
      userId: map['userId'] ?? '',
      quizId: map['quizId'] ?? '',
      quizTitle: map['quizTitle'] ?? '',
      score: map['score'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 0,
      userAnswers:
          List<int>.from(map['userAnswers'] as List<dynamic>? ?? []),
      timeSpent: map['timeSpent'] ?? 0,
      completedAt: completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'quizId': quizId,
      'quizTitle': quizTitle,
      'score': score,
      'totalQuestions': totalQuestions,
      'userAnswers': userAnswers,
      'timeSpent': timeSpent,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}
