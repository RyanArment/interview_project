import 'package:flutter/material.dart';

import 'repositories/mock_todo_repository.dart';
import 'repositories/todo_repository.dart';

void main() {
  // Initialize the mock repository with 1000 random todos
  final TodoRepository todoRepository = MockTodoRepository(count: 1000);

  runApp(MyApp(todoRepository: todoRepository));
}

class MyApp extends StatelessWidget {
  final TodoRepository todoRepository;

  const MyApp({super.key, required this.todoRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Interview Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TodoListPlaceholder(),
    );
  }
}

/// Placeholder widget - This is where you'll implement your solution
class TodoListPlaceholder extends StatelessWidget {
  const TodoListPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.checklist, size: 100, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              'Todo List Implementation',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Implement an infinite scroll list here with search and filter capabilities',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // This is where your implementation will go
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Start implementing the Todo list view here!',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
