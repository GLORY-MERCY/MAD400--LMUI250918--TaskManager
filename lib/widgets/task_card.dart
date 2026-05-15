import 'package:flutter/material.dart';
import '../task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  // Priority color helper
  Color _priorityColor() {
    if (task.priority == 'High') return Colors.red;
    if (task.priority == 'Medium') return Colors.orange;
    return Colors.green;
  }

  // Category icon helper
  IconData _categoryIcon() {
    if (task.category == 'School') return Icons.school;
    if (task.category == 'Personal') return Icons.person;
    return Icons.favorite; // Health
  }

  @override
  Widget build(BuildContext context) {
    // Check if task is overdue
    final bool isOverdue =
        !task.isCompleted && task.dueDate.isBefore(DateTime.now());

    return Card(
      color: isOverdue ? Colors.red.shade50 : null, // 👈 red tint if overdue
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: Icon(_categoryIcon(), color: _priorityColor()),

        // Title with strikethrough if completed
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isCompleted ? Colors.grey : null,
          ),
        ),

        subtitle: Text(
          '${task.category} • ${task.priority} • '
          '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
          style: TextStyle(
            color: isOverdue ? Colors.red : Colors.grey,
          ),
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Checkmark button
            IconButton(
              icon: Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.isCompleted ? Colors.green : Colors.grey,
              ),
              onPressed: onToggle,
            ),
            // Delete button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}