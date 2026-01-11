class Subject {
  final String id;
  final String name;
  final String description;
  final String icon; // Icon name
  final String color; // Hex color code
  final List<Lesson> lessons;

  Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.lessons,
  });
}

class Lesson {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final int quizzesCount;

  Lesson({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.quizzesCount,
  });
}
