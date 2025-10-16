import 'package:faker/faker.dart';

import '../models/paginated_response.dart';
import '../models/todo.dart';
import '../models/todo_filter.dart';
import 'todo_repository.dart';

/// Mock implementation of TodoRepository for testing and development
/// This repository generates random todos and simulates network delays
class MockTodoRepository implements TodoRepository {
  final List<Todo> _allTodos = [];
  final Faker _faker = Faker();

  /// Creates a new instance and generates [count] random todos
  MockTodoRepository({int count = 1000}) {
    _generateTodos(count);
  }

  /// Generates random todos
  void _generateTodos(int count) {
    final now = DateTime.now();

    for (int i = 0; i < count; i++) {
      _allTodos.add(
        Todo(
          id: 'todo_$i',
          title: _faker.lorem.sentence(),
          description: _faker.lorem.sentences(3).join(' '),
          isActive: _faker.randomGenerator.boolean(),
          createdAt: now.subtract(
            Duration(days: _faker.randomGenerator.integer(365)),
          ),
        ),
      );
    }
  }

  @override
  Future<PaginatedResponse<Todo>> getTodos({
    required int page,
    required int pageSize,
    String? searchQuery,
    TodoFilter filter = TodoFilter.all,
  }) async {
    // Simulate network delay (200-500ms)
    await Future.delayed(
      Duration(milliseconds: 200 + _faker.randomGenerator.integer(300)),
    );

    // Start with all todos
    List<Todo> filteredTodos = List.from(_allTodos);

    // Apply filter
    if (filter == TodoFilter.active) {
      filteredTodos = filteredTodos.where((todo) => todo.isActive).toList();
    } else if (filter == TodoFilter.inactive) {
      filteredTodos = filteredTodos.where((todo) => !todo.isActive).toList();
    }

    // Apply search query
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filteredTodos = filteredTodos.where((todo) {
        return todo.title.toLowerCase().contains(query) ||
            todo.description.toLowerCase().contains(query);
      }).toList();
    }

    // Calculate pagination
    final totalCount = filteredTodos.length;
    final startIndex = (page - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalCount);

    // Get the page items
    final pageItems = startIndex < totalCount
        ? filteredTodos.sublist(startIndex, endIndex)
        : <Todo>[];

    // Check if there are more pages
    final hasMore = endIndex < totalCount;

    return PaginatedResponse(
      items: pageItems,
      totalCount: totalCount,
      currentPage: page,
      pageSize: pageSize,
      hasMore: hasMore,
    );
  }

  @override
  int getTotalCount() => _allTodos.length;

  @override
  int getActiveCount() => _allTodos.where((todo) => todo.isActive).length;

  @override
  int getInactiveCount() => _allTodos.where((todo) => !todo.isActive).length;
}
