import '../models/paginated_response.dart';
import '../models/todo.dart';
import '../models/todo_filter.dart';

/// Abstract repository interface for Todo operations
abstract class TodoRepository {
  /// Fetches a paginated list of todos
  ///
  /// Parameters:
  /// - [page]: The page number to fetch (1-based indexing)
  /// - [pageSize]: Number of items per page
  /// - [searchQuery]: Optional search term to filter todos by title or description
  /// - [filter]: Filter by todo status (all, active, or inactive)
  ///
  /// Returns a [PaginatedResponse] containing the todos and pagination metadata
  Future<PaginatedResponse<Todo>> getTodos({
    required int page,
    required int pageSize,
    String? searchQuery,
    TodoFilter filter = TodoFilter.all,
  });

  /// Gets the total count of todos (useful for statistics)
  int getTotalCount();

  /// Gets the count of active todos
  int getActiveCount();

  /// Gets the count of inactive todos
  int getInactiveCount();
}
