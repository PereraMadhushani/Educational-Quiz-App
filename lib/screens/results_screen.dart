import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';

class ResultsScreen extends StatefulWidget {
  final Quiz quiz;
  final QuizResult result;

  const ResultsScreen({
    super.key,
    required this.quiz,
    required this.result,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getPerformanceMessage(double percentage) {
    if (percentage >= 90) return 'Outstanding! 🌟';
    if (percentage >= 80) return 'Excellent Work! 🎉';
    if (percentage >= 70) return 'Great Job! 👏';
    if (percentage >= 60) return 'Good Effort! 💪';
    if (percentage >= 50) return 'Keep Practicing! 📚';
    return 'Don\'t Give Up! 💡';
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 70) return const Color(0xFF10B981);
    if (percentage >= 50) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  IconData _getScoreIcon(double percentage) {
    if (percentage >= 90) return Icons.emoji_events;
    if (percentage >= 70) return Icons.star;
    if (percentage >= 50) return Icons.thumb_up;
    return Icons.lightbulb_outline;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.result.percentageScore;
    final scoreColor = _getScoreColor(percentage);
    final correctAnswers = widget.result.score;
    final incorrectAnswers = widget.result.totalQuestions - widget.result.score;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          title: const Text('Quiz Results'),
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
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Animated Score Card
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: scoreColor.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Icon
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                scoreColor,
                                scoreColor.withOpacity(0.7),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: scoreColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            _getScoreIcon(percentage),
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Performance Message
                        Text(
                          _getPerformanceMessage(percentage),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.quiz.title,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Score Circle
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 160,
                              height: 160,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: percentage / 100),
                                duration: const Duration(milliseconds: 1500),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) {
                                  return CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: 12,
                                    backgroundColor: const Color(0xFFE5E7EB),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      scoreColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: percentage),
                                  duration: const Duration(milliseconds: 1500),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    return Text(
                                      '${value.toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: scoreColor,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.result.score}/${widget.result.totalQuestions}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Statistics Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Correct',
                      correctAnswers.toString(),
                      Icons.check_circle,
                      const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Incorrect',
                      incorrectAnswers.toString(),
                      Icons.cancel,
                      const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Accuracy Card
              _buildFullWidthStatCard(
                'Accuracy',
                '${percentage.toStringAsFixed(1)}%',
                Icons.analytics,
                const Color(0xFF6366F1),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              Column(
                children: [
                  // Review Answers Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        _showReviewDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6366F1),
                        elevation: 0,
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
                          Icon(Icons.list_alt, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Review Answers',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Back to Home Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        final userId =
                            context.read<AuthProvider>().currentUser?.uid;

                        if (userId != null) {
                          context
                              .read<QuizProvider>()
                              .fetchUserStatistics(userId);
                          context.read<QuizProvider>().fetchUserResults(userId);
                        }

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Back to Home',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
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
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
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
                Icons.list_alt,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Review Answers',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              widget.quiz.questions.length,
              (index) {
                final question = widget.quiz.questions[index];
                final userAnswer = widget.result.userAnswers[index];
                final correctAnswer = question.correctAnswerIndex;
                final isCorrect = userAnswer == correctAnswer;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? const Color(0xFF10B981).withOpacity(0.1)
                        : const Color(0xFFEF4444).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCorrect
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCorrect ? Icons.check : Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Question ${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCorrect
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        question.questionText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (!isCorrect) ...[
                        Text(
                          'Your answer: ${question.options[userAnswer]}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        'Correct answer: ${question.options[correctAnswer]}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Close',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}