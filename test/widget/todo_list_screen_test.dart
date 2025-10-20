import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_project/bloc/todo_bloc.dart';
import 'package:interview_project/main.dart';
import 'package:interview_project/models/paginated_response.dart';
import 'package:interview_project/models/todo.dart';
import 'package:interview_project/models/todo_filter.dart';
import 'package:interview_project/repositories/todo_repository.dart';
import 'package:mocktail/mocktail.dart';

// Mock repository for widget tests
class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  // Register fallback values for mocktail - required for enums
  setUpAll(() {
    registerFallbackValue(TodoFilter.all);
  });

  group('TodoListScreen Widget Tests', () {
    late TodoRepository mockRepository;

    final sampleTodos = [
      Todo(
        id: '1',
        title: 'Buy groceries',
        description: 'Milk, eggs, bread',
        isActive: true,
        createdAt: DateTime(2024, 1, 1),
      ),
      Todo(
        id: '2',
        title: 'Finish project',
        description: 'Complete the Flutter app',
        isActive: true,
        createdAt: DateTime(2024, 1, 2),
      ),
    ];

    final sampleResponse = PaginatedResponse<Todo>(
      items: sampleTodos,
      totalCount: 2,
      currentPage: 1,
      pageSize: 20,
      hasMore: false,
    );

    setUp(() {
      mockRepository = MockTodoRepository();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: BlocProvider(
          create: (context) => TodoBloc(repository: mockRepository),
          child: const TodoListScreen(),
        ),
      );
    }

    testWidgets('displays todos after loading', (WidgetTester tester) async {
      when(() => mockRepository.getTodos(
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
            filter: any(named: 'filter'),
          )).thenAnswer((_) async => sampleResponse);

      await tester.pumpWidget(createTestWidget());
      
      final context = tester.element(find.byType(TodoListScreen));
      context.read<TodoBloc>().add(LoadInitial());

      await tester.pumpAndSettle();
      
      expect(find.text('Buy groceries'), findsOneWidget);
      expect(find.text('Finish project'), findsOneWidget);
    });

    testWidgets('allows user to search todos', (WidgetTester tester) async {
      when(() => mockRepository.getTodos(
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
            filter: any(named: 'filter'),
            searchQuery: any(named: 'searchQuery'),
          )).thenAnswer((_) async => sampleResponse);

      await tester.pumpWidget(createTestWidget());
      
      final context = tester.element(find.byType(TodoListScreen));
      context.read<TodoBloc>().add(LoadInitial());
      await tester.pumpAndSettle();

      // User types in search field
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'groceries');
      
      expect(find.text('groceries'), findsOneWidget);
      
      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
    });

    testWidgets('displays error message on failure',
        (WidgetTester tester) async {
      when(() => mockRepository.getTodos(
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
            filter: any(named: 'filter'),
          )).thenThrow(Exception('Network error'));

      await tester.pumpWidget(createTestWidget());
      
      final context = tester.element(find.byType(TodoListScreen));
      context.read<TodoBloc>().add(LoadInitial());
      
      await tester.pumpAndSettle();

      expect(find.textContaining('error'), findsOneWidget);
    });
  });
}

