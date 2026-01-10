import 'package:flutter/foundation.dart';
import '../models/quiz.dart';
import '../services/firebase_service.dart';

class QuizProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<Quiz> _quizzes = [];
  List<QuizResult> _userResults = [];
  Quiz? _currentQuiz;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _userStats = {};

  List<Quiz> get quizzes => _quizzes;
  List<QuizResult> get userResults => _userResults;
  Quiz? get currentQuiz => _currentQuiz;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get userStats => _userStats;

  Future<void> fetchAllQuizzes() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _quizzes = await _firebaseService.getAllQuizzes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
       _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchQuizzesByTopic(String topic) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _quizzes = await _firebaseService.getQuizzesByTopic(topic);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadQuiz(String quizId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentQuiz = await _firebaseService.getQuizById(quizId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitQuizResult(QuizResult result) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firebaseService.saveQuizResult(result);
      _userResults.add(result);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserResults(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _userResults = await _firebaseService.getUserResults(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserStatistics(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _userStats = await _firebaseService.getUserStatistics(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCurrentQuiz() {
    _currentQuiz = null;
    notifyListeners();
  }
}
