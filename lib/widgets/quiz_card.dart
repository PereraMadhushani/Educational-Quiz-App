import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  final String title;
  final String category;
  final int questionCount;
  final int difficulty;
  final VoidCallback onTap;
  final String? image;

  const QuizCard({
    required this.title,
    required this.category,
    required this.questionCount,
    required this.difficulty,
    required this.onTap,
    this.image,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.all(8),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null)
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Image.asset(image!, fit: BoxFit.cover),
                )
              else
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.blue[100],
                  child: const Icon(Icons.quiz, size: 60),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(label: Text(category)),
                        Text('$questionCount Q'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
