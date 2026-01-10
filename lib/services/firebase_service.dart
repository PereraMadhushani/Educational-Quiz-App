import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/quiz.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;

  FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  void initialize() {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
  }

  // Auth Methods
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // Quiz Methods
  Future<List<Quiz>> getAllQuizzes() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('quizzes').get();
      return snapshot.docs
          .map((doc) => Quiz.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Quiz>> getQuizzesStream() {
    return _firestore.collection('quizzes').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  Quiz.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList(),
        );
  }

  Future<Quiz?> getQuizById(String quizId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('quizzes').doc(quizId).get();
      if (doc.exists) {
        return Quiz.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Quiz>> getQuizzesByTopic(String topic) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('quizzes')
          .where('topic', isEqualTo: topic)
          .get();
      return snapshot.docs
          .map((doc) => Quiz.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Quiz Results Methods
  Future<void> saveQuizResult(QuizResult result) async {
    try {
      await _firestore
          .collection('users')
          .doc(result.userId)
          .collection('results')
          .doc(result.id)
          .set(result.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuizResult>> getUserResults(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('results')
          .orderBy('completedAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) =>
              QuizResult.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<QuizResult?> getUserQuizResult(
      String userId, String quizId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('results')
          .where('quizId', isEqualTo: quizId)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return QuizResult.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>,
            snapshot.docs.first.id);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserStatistics(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('results')
          .get();

      int totalQuizzes = snapshot.docs.length;
      int totalScore = 0;
      int totalQuestions = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalScore += (data['score'] as int?) ?? 0;
        totalQuestions += (data['totalQuestions'] as int?) ?? 0;
      }

      double averageScore =
          totalQuestions > 0 ? (totalScore / totalQuestions * 100) : 0;

      return {
        'totalQuizzes': totalQuizzes,
        'averageScore': averageScore,
        'totalScore': totalScore,
        'totalQuestions': totalQuestions,
      };
    } catch (e) {
      rethrow;
    }
  }

  // Admin Methods - Add Quiz
  Future<String> addQuiz(Quiz quiz) async {
    try {
      final docRef = await _firestore.collection('quizzes').add(quiz.toMap());
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    try {
      await _firestore.collection('quizzes').doc(quizId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
