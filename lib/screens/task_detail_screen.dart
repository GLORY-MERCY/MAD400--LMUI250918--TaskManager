import 'package:flutter/material.dart';
import '../task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;  

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit, 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Title
            Text(
              task.title,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Detail rows
            _buildDetailRow(Icons.description, 'Description', task.description),
            _buildDetailRow(Icons.category, 'Category', task.category),
            _buildDetailRow(Icons.flag, 'Priority', task.priority),
            _buildDetailRow(
              Icons.calendar_today,
              'Due Date',
              '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
            ),
            _buildDetailRow(
              Icons.check_circle,
              'Status',
              task.isCompleted ? 'Completed' : 'Pending',
            ),

            const SizedBox(height: 32),

            // Mark complete/incomplete button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(task.isCompleted
                    ? Icons.undo
                    : Icons.check_circle),
                label: Text(task.isCompleted
                    ? 'Mark as Incomplete'
                    : 'Mark as Complete'),
                onPressed: () {
                  onToggle();
                  Navigator.pop(context);
                },
              ),
            ),

            const SizedBox(height: 8),

            // Delete button with confirmation dialog
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Delete Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  // Confirmation dialog
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Task'),
                      content: const Text(
                          'Are you sure you want to delete this task?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    onDelete();
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            const SizedBox(height: 8),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    icon: const Icon(Icons.edit),
    label: const Text('Edit Task'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    onPressed: onEdit,      //  calls the edit function
  ),
),
          ],
        ),
      ),
    );
  }
  // Helper method for detail rows
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}