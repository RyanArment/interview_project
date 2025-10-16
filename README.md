# Todo List Interview Project

## Overview
This is a 30-40 minute coding challenge to assess your Flutter development skills, specifically focusing on:
- Implementing infinite scroll/pagination
- State management
- Search and filtering functionality
- Working with repository patterns and mock data

## What's Already Provided

### Models
- **`Todo`** (`lib/models/todo.dart`): Represents a todo item with:
  - `id`: Unique identifier
  - `title`: Todo title
  - `description`: Detailed description
  - `isActive`: Boolean status (active/inactive)
  - `createdAt`: Creation timestamp

- **`TodoFilter`** (`lib/models/todo_filter.dart`): Enum for filtering todos:
  - `all`: Show all todos
  - `active`: Show only active todos
  - `inactive`: Show only inactive todos

- **`PaginatedResponse<T>`** (`lib/models/paginated_response.dart`): Response wrapper containing:
  - `items`: List of items for current page
  - `totalCount`: Total number of items matching the query
  - `currentPage`: Current page number
  - `pageSize`: Number of items per page
  - `hasMore`: Boolean indicating if more pages are available

### Repository
- **`TodoRepository`** (`lib/repositories/todo_repository.dart`): Abstract interface with methods:
  - `getTodos()`: Fetch paginated todos with optional search and filter
  - `getTotalCount()`: Get total number of todos
  - `getActiveCount()`: Get count of active todos
  - `getInactiveCount()`: Get count of inactive todos

- **`MockTodoRepository`** (`lib/repositories/mock_todo_repository.dart`):
  - Pre-implemented with 1000 random todos
  - Simulates network delays (200-500ms)
  - Supports pagination, search, and filtering
  - Initialized in `main.dart`

## Your Task

Create a **Todo List View** that implements the following features:

### Required Features

1. **Infinite Scroll / Pagination**
   - Display todos in a scrollable list
   - Load more todos automatically when user scrolls near the bottom
   - Show loading indicators while fetching data
   - Handle the end of the list gracefully (no more items to load)

2. **Search Functionality**
   - Add a search bar to filter todos by title or description
   - Search should be applied when fetching from the repository
   - Debounce search input to avoid excessive API calls

3. **Filter Functionality**
   - Provide UI controls to filter todos by status:
     - All todos
     - Active todos only
     - Inactive todos only
   - Apply filter when fetching from the repository

4. **Display Todo Information**
   - Show at minimum the title and active/inactive status
   - Use appropriate UI design (cards, list tiles, etc.)

### Technical Requirements

- Access the repository from `main.dart` (it's already initialized)
- **State Management**: Use one of the following:
  - **Bloc/flutter_bloc** (preferred - demonstrates advanced knowledge)
  - StatefulWidget with setState (acceptable)
  - Provider (acceptable)
- Handle loading states, empty states, and error states
- Ensure smooth scrolling performance
- Keep the code clean and organized

### Suggested Approach

1. Create a new widget to replace `TodoListPlaceholder` in `main.dart`
2. Set up state management (Bloc preferred, StatefulWidget/Provider acceptable) for:
   - List of loaded todos
   - Loading state
   - Current page
   - Search query
   - Selected filter
3. Implement scroll detection for infinite scroll
4. Create UI components for search bar and filter controls
5. Display the todo list with proper loading indicators

**State Management Options:**
- **Bloc/Cubit** (recommended): Create events/states for loading, searching, filtering
- **StatefulWidget**: Use setState with proper state variables
- **Provider**: Create a ChangeNotifier for todo list management

### Evaluation Criteria

- **Functionality**: Does it work as specified?
- **Code Quality**: Clean, readable, and well-organized code
- **State Management**: Proper handling of application state
  - Bloc usage is a strong plus
  - StatefulWidget/Provider are acceptable
- **UI/UX**: Intuitive interface with good user experience
- **Error Handling**: Graceful handling of edge cases

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Available Repository Methods

```dart
// Example usage of the repository
final repository = MockTodoRepository(count: 1000);

// Fetch first page of all todos
final response = await repository.getTodos(
  page: 1,
  pageSize: 20,
  searchQuery: null,
  filter: TodoFilter.all,
);

// Fetch active todos with search
final activeResponse = await repository.getTodos(
  page: 1,
  pageSize: 20,
  searchQuery: 'meeting',
  filter: TodoFilter.active,
);

// Get statistics
final totalCount = repository.getTotalCount();
final activeCount = repository.getActiveCount();
final inactiveCount = repository.getInactiveCount();
```

## Time Management Tips

- **0-10 mins**: Plan your approach and set up the basic structure
- **10-25 mins**: Implement core functionality (list, pagination, basic UI)
- **25-35 mins**: Add search and filter features
- **35-40 mins**: Polish UI, test edge cases, and clean up code

## Notes

- The repository simulates network delays, so you'll see realistic loading behavior
- Don't worry about perfect UI design - focus on functionality first
- If you get stuck, implement the features in order of priority
- Feel free to ask clarifying questions

Good luck! 🚀
