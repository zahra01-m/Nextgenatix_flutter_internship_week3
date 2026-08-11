import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';

/// To-Do List screen — Week 3.
///
/// Implements CRUD operations (Create, Read, Update, Delete) on a local
/// in-memory list of [Task]s, using setState() for state management.
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  // READ: the local list of tasks (Dart List)
  final List<Task> _tasks = [
    Task(title: 'Learn Flutter basics'),
    Task(title: 'Build Splash & Login UI', isCompleted: true),
    Task(title: 'Practice CRUD operations'),
  ];

  // CREATE: add a new task
  void _addTask(String title) {
    if (title.trim().isEmpty) return;
    setState(() {
      _tasks.add(Task(title: title.trim()));
    });
  }

  // UPDATE: edit an existing task's title
  void _editTask(int index, String newTitle) {
    if (newTitle.trim().isEmpty) return;
    setState(() {
      _tasks[index].title = newTitle.trim();
    });
  }

  // UPDATE: toggle completed status
  void _toggleComplete(int index, bool? value) {
    setState(() {
      _tasks[index].isCompleted = value ?? false;
    });
  }

  // DELETE: remove a task
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _showTaskDialog({int? editIndex}) {
    final isEditing = editIndex != null;
    final controller = TextEditingController(
      text: isEditing ? _tasks[editIndex].title : '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(isEditing ? 'Edit Task' : 'Add Task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter task title',
              filled: true,
              fillColor: const Color(0xFFF5F4FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE84393),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (isEditing) {
                  _editTask(editIndex, controller.text);
                } else {
                  _addTask(controller.text);
                }
                Navigator.pop(context);
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FC),
        elevation: 0,
        title: const Text(
          'My Tasks',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$completedCount of ${_tasks.length} tasks completed',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 16),

              // READ: display tasks using ListView.builder
              Expanded(
                child: _tasks.isEmpty
                    ? Center(
                  child: Text(
                    'No tasks yet. Tap + to add one!',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                )
                    : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return TaskTile(
                      task: task,
                      onToggleComplete: (value) => _toggleComplete(index, value),
                      onEdit: () => _showTaskDialog(editIndex: index),
                      onDelete: () => _deleteTask(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE84393),
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}