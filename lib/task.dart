class Task {
  String title;        // The name of the task
  String description;  // Details about the task
  String category;     // School, Personal, or Health
  String priority;     // Low, Medium, or High
  DateTime dueDate;    // When the task is due
  bool isCompleted;    // Whether the task is done

  Task({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
  });
}