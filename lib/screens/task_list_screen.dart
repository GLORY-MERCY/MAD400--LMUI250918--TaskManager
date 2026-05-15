import 'package:flutter/material.dart';
import '../task.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {

  // ── VARIABLES ──────────────────────────────────────────
  List<Task> tasks = [];
  String _filter = 'All'; // can be 'All', 'Pending', or 'Completed'
  String _sort = 'None'; // can be 'Date' or 'Priority'
  String _searchQuery = '';
bool _isSearching = false;
final TextEditingController _searchController = TextEditingController();

  //  Filtered Tasks Getter
 List<Task> get _filteredTasks {
  List<Task> result = tasks;

  //  search filter 
  if (_searchQuery.isNotEmpty) {
    result = result
        .where((t) =>
            t.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  // tab filter
  if (_filter == 'Pending') {
    result = result.where((t) => !t.isCompleted).toList();
  } else if (_filter == 'Completed') {
    result = result.where((t) => t.isCompleted).toList();
  }

  return result;
}
// Sorted Tasks Getter
List<Task> get _sortedTasks {
  List<Task> result = _filteredTasks;

  if (_sort == 'Date') {
    result.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  } else if (_sort == 'Priority') {
    const order = {'High': 0, 'Medium': 1, 'Low': 2};
    result.sort((a, b) => order[a.priority]!.compareTo(order[b.priority]!));
  }

  return result;
}
  // ── METHODS ────────────────────────────────────────────
  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _toggleTask(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void _showAddTaskSheet() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'School';
    String selectedPriority = 'Medium';
    DateTime? selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add New Task',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    decoration:
                        const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration:
                        const InputDecoration(labelText: 'Category'),
                    items: ['School', 'Personal', 'Health']
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) =>
                        setSheetState(() => selectedCategory = value!),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedPriority,
                    decoration:
                        const InputDecoration(labelText: 'Priority'),
                    items: ['Low', 'Medium', 'High']
                        .map((p) =>
                            DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (value) =>
                        setSheetState(() => selectedPriority = value!),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(selectedDate == null
                          ? 'No date chosen'
                          : 'Due: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setSheetState(() => selectedDate = picked);
                          }
                        },
                        child: const Text('Pick Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isEmpty ||
                          descriptionController.text.isEmpty ||
                          selectedDate == null) {
                        return;
                      }
                      final newTask = Task(
                        title: titleController.text,
                        description: descriptionController.text,
                        category: selectedCategory,
                        priority: selectedPriority,
                        dueDate: selectedDate!,
                      );
                      _addTask(newTask);
                      Navigator.pop(context);
                    },
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditTaskSheet(int index) {
    final task = tasks[index];
    // Pre-fill controllers with existing task data
    final titleController = TextEditingController(text: task.title);
    final descriptionController =
        TextEditingController(text: task.description);
    String selectedCategory = task.category;
    String selectedPriority = task.priority;
    DateTime? selectedDate = task.dueDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Edit Task',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    decoration:
                        const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration:
                        const InputDecoration(labelText: 'Category'),
                    items: ['School', 'Personal', 'Health']
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) =>
                        setSheetState(() => selectedCategory = value!),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedPriority,
                    decoration:
                        const InputDecoration(labelText: 'Priority'),
                    items: ['Low', 'Medium', 'High']
                        .map((p) =>
                            DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (value) =>
                        setSheetState(() => selectedPriority = value!),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Due: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate!,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setSheetState(() => selectedDate = picked);
                          }
                        },
                        child: const Text('Change Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isEmpty ||
                          descriptionController.text.isEmpty) {
                        return;
                      }
                      // Update the existing task
                      setState(() {
                        tasks[index].title = titleController.text;
                        tasks[index].description = descriptionController.text;
                        tasks[index].category = selectedCategory;
                        tasks[index].priority = selectedPriority;
                        tasks[index].dueDate = selectedDate!;
                      });
                      Navigator.pop(context); // close sheet
                      Navigator.pop(context); // close detail screen
                    },
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── BUILD ───────────────────────────────────────────────
  @override
Widget build(BuildContext context) {
  // Stats calculations
  final int total = tasks.length;
  final int completed = tasks.where((t) => t.isCompleted).length;
  final int pending = total - completed;
  final double progress = total == 0 ? 0 : completed / total;

  return Scaffold(
    appBar: AppBar(
  title: _isSearching
      ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search tasks...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        )
      : const Text('My Tasks'),
  actions: [
    // Search icon
    IconButton(
      icon: Icon(_isSearching ? Icons.close : Icons.search),
      onPressed: () {
        setState(() {
          _isSearching = !_isSearching;
          if (!_isSearching) {
            _searchQuery = '';
            _searchController.clear();
          }
        });
      },
    ),

    // Clear all icon
    IconButton(
      icon: const Icon(Icons.delete_sweep),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Clear All Tasks'),
            content: const Text(
                'Are you sure you want to delete all tasks?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Clear All'),
              ),
            ],
          ),
        );

        if (confirm == true) {
          setState(() => tasks.clear());
        }
      },
    ),

    // Sort icon
    PopupMenuButton<String>(
      icon: const Icon(Icons.sort),
      onSelected: (value) {
        setState(() => _sort = value);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'None', child: Text('No Sorting')),
        const PopupMenuItem(value: 'Date', child: Text('Sort by Due Date')),
        const PopupMenuItem(
            value: 'Priority', child: Text('Sort by Priority')),
      ],
    ),
  ],
),
    body: Column(
      children: [
        // ── STATISTICS BAR ──────────────────────────────
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey.shade100,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Total', total, Colors.blue),
                  _buildStat('Completed', completed, Colors.green),
                  _buildStat('Pending', pending, Colors.orange),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade300,
                color: Colors.green,
                minHeight: 8,
              ),
              const SizedBox(height: 4),
              Text(
                '${(progress * 100).toStringAsFixed(0)}% completed',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),

        // ── FILTER BUTTONS ───────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['All', 'Pending', 'Completed'].map((filter) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(filter),
                  selected: _filter == filter,
                  onSelected: (selected) {
                    setState(() => _filter = filter);
                  },
                ),
              );
            }).toList(),
          ),
        ),

        // ── TASK LIST ────────────────────────────────────
        Expanded(
          child: _sortedTasks.isEmpty
              ? const Center(child: Text('No tasks here!'))
              : ListView.builder(
                  itemCount: _sortedTasks.length,
                  itemBuilder: (context, index) {
                    final task = _sortedTasks[index];
                    final realIndex = tasks.indexOf(task);
                    return Dismissible(
                      key: Key(task.title + realIndex.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteTask(realIndex);
                      },
                      child: TaskCard(
                        task: task,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(
                                task: task,
                                onToggle: () => _toggleTask(realIndex),
                                onDelete: () => _deleteTask(realIndex),
                                onEdit: () => _showEditTaskSheet(realIndex),
                              ),
                            ),
                          );
                        },
                        onToggle: () => _toggleTask(realIndex),
                        onDelete: () => _deleteTask(realIndex),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showAddTaskSheet,
      child: const Icon(Icons.add),
    ),
  );
}
}

// Helper method for stat display
Widget _buildStat(String label, int value, Color color) {
  return Column(
    children: [
      Text(
        value.toString(),
        style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: color),
      ),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ],
  );
}