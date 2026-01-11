import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz.dart';
import '../models/subject.dart';

class QuizService {
  // Initialize subjects with lessons
  final List<Subject> _subjects = [
    Subject(
      id: 'bio',
      name: 'Biology',
      description: 'Learn about living organisms',
      icon: 'biology',
      color: '0x06B6D4',
      lessons: [
        Lesson(id: 'bio_1', subjectId: 'bio', title: 'Human Body', description: 'Body systems and anatomy', quizzesCount: 1),
        Lesson(id: 'bio_2', subjectId: 'bio', title: 'Cells', description: 'Cell structure and function', quizzesCount: 1),
        Lesson(id: 'bio_3', subjectId: 'bio', title: 'Genetics', description: 'DNA and heredity', quizzesCount: 1),
        Lesson(id: 'bio_4', subjectId: 'bio', title: 'Evolution', description: 'Natural selection and adaptation', quizzesCount: 1),
        Lesson(id: 'bio_5', subjectId: 'bio', title: 'Ecology', description: 'Ecosystems and biodiversity', quizzesCount: 1),
      ],
    ),
    Subject(
      id: 'chem',
      name: 'Chemistry',
      description: 'Study matter and reactions',
      icon: 'chemistry',
      color: '0x14B8A6',
      lessons: [
        Lesson(id: 'chem_1', subjectId: 'chem', title: 'Atomic Structure', description: 'Learn about atoms and elements', quizzesCount: 1),
        Lesson(id: 'chem_2', subjectId: 'chem', title: 'Chemical Bonding', description: 'Understand how atoms bond', quizzesCount: 1),
        Lesson(id: 'chem_3', subjectId: 'chem', title: 'Acid & Bases', description: 'pH and acid-base chemistry', quizzesCount: 1),
        Lesson(id: 'chem_4', subjectId: 'chem', title: 'Thermodynamics', description: 'Energy and heat in reactions', quizzesCount: 1),
        Lesson(id: 'chem_5', subjectId: 'chem', title: 'Chemical Reactions', description: 'Explore types of reactions', quizzesCount: 1),
      ],
    ),
    Subject(
      id: 'phys',
      name: 'Physics',
       description: 'Laws of nature',
      icon: 'physics',
      color: '0xF97316',
      lessons: [
        Lesson(id: 'phys_1', subjectId: 'phys', title: 'Motion', description: 'Forces and motion', quizzesCount: 1),
        Lesson(id: 'phys_2', subjectId: 'phys', title: 'Energy', description: 'Kinetic and potential energy', quizzesCount: 1),
        Lesson(id: 'phys_3', subjectId: 'phys', title: 'Waves', description: 'Sound and light waves', quizzesCount: 1),
        Lesson(id: 'phys_4', subjectId: 'phys', title: 'Electricity', description: 'Electric charge and circuits', quizzesCount: 1),
        Lesson(id: 'phys_5', subjectId: 'phys', title: 'Magnetism', description: 'Magnetic fields and forces', quizzesCount: 1),
      ],
    ),
  ];



  List<Subject> getAllSubjects() => _subjects;

  // Fetch all quizzes from Firebase
  Future<List<Quiz>> getAllQuizzesFromFirebase() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .get();
      
      List<Quiz> quizzes = [];
      for (var doc in snapshot.docs) {
        final quizData = doc.data() as Map<String, dynamic>;
        
        // Fetch questions for this quiz
        final questionsSnapshot = await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(doc.id)
            .collection('questions')
            .get();
        
        final questions = questionsSnapshot.docs
            .map((qDoc) => Question.fromMap(qDoc.data() as Map<String, dynamic>))
            .toList();
        
        quizzes.add(
          Quiz(
            id: doc.id,
            title: quizData['title'] ?? '',
            description: quizData['description'] ?? '',
            topic: quizData['topic'] ?? '',
            totalQuestions: questions.length,
            timeLimit: (quizData['timeLimit'] ?? 0).toInt(),
            questions: questions,
            createdAt: (quizData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            lessonId: quizData['lessonId'] ?? '',
          ),
        );
      }
      
      return quizzes;
    } catch (e) {
      print('Error fetching all quizzes from Firebase: $e');
      return [];
    }
  }

  // Fetch quizzes by lesson from Firebase
  Future<List<Quiz>> getQuizzesByLessonFromFirebase(String lessonId) async {
    try {
      // Load ALL quizzes first (workaround for missing index)
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .get();
      
      List<Quiz> quizzes = [];
      for (var doc in snapshot.docs) {
        final quizData = doc.data() as Map<String, dynamic>;
        
        // Filter by lessonId in code (handle both 'lessonId' and 'lessonId ' with space)
        final storedLessonId = quizData['lessonId'] ?? quizData['lessonId '];
        
        if (storedLessonId != lessonId) {
          continue;
        }
        
        // Fetch questions - they might be embedded in the document or in a subcollection
        List<Question> questions = [];
        
        // First, try to get questions from embedded array in the document
        if (quizData['questions'] != null && (quizData['questions'] as List).isNotEmpty) {
          questions = (quizData['questions'] as List)
              .map((q) => Question.fromMap(q as Map<String, dynamic>))
              .toList();
        } else {
          // Otherwise, try to fetch from subcollection
          final questionsSnapshot = await FirebaseFirestore.instance
              .collection('quizzes')
              .doc(doc.id)
              .collection('questions')
              .get();
          
          questions = questionsSnapshot.docs
              .map((qDoc) => Question.fromMap(qDoc.data() as Map<String, dynamic>))
              .toList();
        }
        
        quizzes.add(
          Quiz(
            id: doc.id,
            title: quizData['title'] ?? '',
            description: quizData['description'] ?? '',
            topic: quizData['topic'] ?? '',
            totalQuestions: questions.length,
            timeLimit: (quizData['timeLimit'] ?? 0).toInt(),
            questions: questions,
            createdAt: (quizData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            lessonId: storedLessonId ?? '',
          ),
        );
      }
      
      return quizzes;
    } catch (e) {
      print('Error fetching quizzes by lesson from Firebase: $e');
      return [];
    }
  }

  // Fetch quiz by ID from Firebase
  Future<Quiz?> getQuizByIdFromFirebase(String quizId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(quizId)
          .get();
      
      if (!doc.exists) return null;
      
      final quizData = doc.data() as Map<String, dynamic>;
      
      // Fetch questions for this quiz
      final questionsSnapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .get();
      
      final questions = questionsSnapshot.docs
          .map((qDoc) => Question.fromMap(qDoc.data() as Map<String, dynamic>))
          .toList();
      
      return Quiz(
        id: doc.id,
        title: quizData['title'] ?? '',
        description: quizData['description'] ?? '',
        topic: quizData['topic'] ?? '',
        totalQuestions: questions.length,
        timeLimit: (quizData['timeLimit'] ?? 0).toInt(),
        questions: questions,
        createdAt: (quizData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        lessonId: quizData['lessonId'] ?? '',
      );
    } catch (e) {
      print('Error getting quiz from Firebase: $e');
      return null;
    }
  }

  // Fetch quizzes by topic from Firebase
  Future<List<Quiz>> getQuizzesByTopicFromFirebase(String topic) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .where('topic', isEqualTo: topic)
          .get();
      
      List<Quiz> quizzes = [];
      for (var doc in snapshot.docs) {
        final quizData = doc.data() as Map<String, dynamic>;
        
        // Fetch questions for this quiz
        final questionsSnapshot = await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(doc.id)
            .collection('questions')
            .get();
        
        final questions = questionsSnapshot.docs
            .map((qDoc) => Question.fromMap(qDoc.data() as Map<String, dynamic>))
            .toList();
        
        quizzes.add(
          Quiz(
            id: doc.id,
            title: quizData['title'] ?? '',
            description: quizData['description'] ?? '',
            topic: quizData['topic'] ?? '',
            totalQuestions: questions.length,
            timeLimit: (quizData['timeLimit'] ?? 0).toInt(),
            questions: questions,
            createdAt: (quizData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            lessonId: quizData['lessonId'] ?? '',
          ),
        );
      }
      
      return quizzes;
    } catch (e) {
      print('Error fetching quizzes by topic from Firebase: $e');
      return [];
    }
  }

  // Fetch questions from Firebase for a specific quiz
  Future<List<Question>> _fetchQuestionsFromFirebase(String quizId) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .get();
      
      return snapshot.docs
          .map((doc) => Question.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching questions from Firebase: $e');
      return [];
    }
  }

  // Legacy methods for backward compatibility (deprecated - use Firebase methods above)
  @Deprecated('Use getQuizzesByLessonFromFirebase instead')
  List<Quiz> getQuizzesByLesson(String lessonId) => [];

  @Deprecated('Use getAllQuizzesFromFirebase instead')
  Future<List<Quiz>> getAllQuizzes() async {
    return getAllQuizzesFromFirebase();
  }

  @Deprecated('Use getQuizzesByTopicFromFirebase instead')
  Future<List<Quiz>> getQuizzesByCategory(String category) async {
    return getQuizzesByTopicFromFirebase(category);
  }

  @Deprecated('Use getQuizByIdFromFirebase instead')
  Future<Quiz?> getQuizById(String id) async {
    return getQuizByIdFromFirebase(id);
  }

  Future<void> saveQuizResult(QuizResult result) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Save result to database
  }
}
