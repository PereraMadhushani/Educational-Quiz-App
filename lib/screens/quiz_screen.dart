import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
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
  late Timer _timer;
  int _secondsRemaining = 0;
  bool _timeExpired = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userAnswers = List<int?>.filled(widget.quiz.questions.length, null);
    
    // Initialize timer: convert minutes to seconds with proper null/type checks
    int timeLimit = widget.quiz.timeLimit ?? 0;
    if (timeLimit <= 0) {
      timeLimit = 15; // Default to 15 minutes if invalid
    }
    _secondsRemaining = timeLimit * 60;
    
    // Only start timer if seconds is valid
    if (_secondsRemaining > 0) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timeExpired = true;
          _timer.cancel();
          _handleTimeExpired();
        }
      });
    });
  }

  void _handleTimeExpired() {
    _timer.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.schedule,
                color: Color(0xFFEF4444),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Time Expired!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: const Text(
          'Your time has expired. Your quiz will be submitted automatically.',
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 16,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performSubmit(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
            ),
            child: const Text(
              'Submit Quiz',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    // Handle NaN or invalid values
    if (seconds.isNaN || seconds < 0) {
      return '00:00';
    }
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getTimerColor() {
    if (_secondsRemaining <= 60) {
      return const Color(0xFFEF4444); // Red if less than 1 minute
    } else if (_secondsRemaining <= 300) {
      return const Color(0xFFF59E0B); // Orange if less than 5 minutes
    }
    return const Color(0xFF10B981); // Green otherwise
  }

  bool _isTimerValid() {
    return !_secondsRemaining.isNaN && _secondsRemaining >= 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF8B5CF6),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Submit Quiz?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to submit this quiz?',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
              ),
            ),
            if (unansweredCount > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFF59E0B),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFF59E0B),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$unansweredCount question(s) not answered',
                        style: const TextStyle(
                          color: Color(0xFFD97706),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
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
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performSubmit(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
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
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(widget.quiz.title),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
                Color(0xFFEC4899),
              ],
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text('Exit Quiz?'),
                content: const Text(
                  'Your progress will be lost. Are you sure you want to exit?',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Exit',
                      style: TextStyle(color: Color(0xFFEF4444)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: widget.quiz.questions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.quiz_outlined,
                      size: 64,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No questions available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Progress Bar Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${_currentQuestion + 1}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF6366F1),
                                  Color(0xFF8B5CF6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_currentQuestion + 1}/${widget.quiz.questions.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Timer Display
                      if (_isTimerValid())
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getTimerColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getTimerColor().withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.schedule,
                                color: _getTimerColor(),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Time Remaining: ${_formatTime(_secondsRemaining)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _getTimerColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (_currentQuestion + 1) / widget.quiz.questions.length,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE5E7EB),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF6366F1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Question Cards
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
                            // Question Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6366F1).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Question',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF6366F1),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    question.questionText,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1F2937),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Options Label
                            const Padding(
                              padding: EdgeInsets.only(left: 4, bottom: 12),
                              child: Text(
                                'Choose your answer:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            
                            // Answer Options
                            ...List.generate(
                              question.options.length,
                              (optionIndex) {
                                final isSelected = _userAnswers[index] == optionIndex;
                                final optionLabels = ['A', 'B', 'C', 'D', 'E'];
                                
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _userAnswers[index] = optionIndex;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFF6366F1).withOpacity(0.1)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFF6366F1)
                                                : const Color(0xFFE5E7EB),
                                            width: isSelected ? 2 : 1,
                                          ),
                                          boxShadow: [
                                            if (isSelected)
                                              BoxShadow(
                                                color: const Color(0xFF6366F1).withOpacity(0.2),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                gradient: isSelected
                                                    ? const LinearGradient(
                                                        colors: [
                                                          Color(0xFF6366F1),
                                                          Color(0xFF8B5CF6),
                                                        ],
                                                      )
                                                    : null,
                                                color: isSelected
                                                    ? null
                                                    : const Color(0xFFF3F4F6),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  optionLabels[optionIndex],
                                                  style: TextStyle(
                                                    color: isSelected
                                                        ? Colors.white
                                                        : const Color(0xFF6B7280),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                question.options[optionIndex],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: isSelected
                                                      ? const Color(0xFF1F2937)
                                                      : const Color(0xFF4B5563),
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            if (isSelected)
                                              const Icon(
                                                Icons.check_circle,
                                                color: Color(0xFF6366F1),
                                                size: 24,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // Navigation Buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        if (_currentQuestion > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(
                                  color: Color(0xFF6366F1),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_back, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Previous',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (_currentQuestion > 0) const SizedBox(width: 12),
                        Expanded(
                          flex: _currentQuestion > 0 ? 1 : 1,
                          child: ElevatedButton(
                            onPressed: _currentQuestion < widget.quiz.questions.length - 1
                                ? () => _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    )
                                : () => _submitQuiz(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentQuestion < widget.quiz.questions.length - 1
                                      ? 'Next'
                                      : 'Submit Quiz',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  _currentQuestion < widget.quiz.questions.length - 1
                                      ? Icons.arrow_forward
                                      : Icons.check_circle_outline,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}