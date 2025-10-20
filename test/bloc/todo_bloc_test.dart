import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_project/bloc/todo_bloc.dart';
import 'package:interview_project/models/paginated_response.dart';
import 'package:interview_project/models/todo.dart';
import 'package:interview_project/models/todo_filter.dart';
import 'package:interview_project/repositories/todo_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  group('TodoBloc', () {
    late TodoRepository mockRepository;
    late TodoBloc todoBloc;

    final sampleTodos = [
      Todo(
        id: '1',
        title: 'Test Todo',
        description: 'Description',
        isActive: true,
        createdAt: DateTime(2024, 1, 1),
      ),
    ];

    final sampleResponse = PaginatedResponse<Todo>(
      items: sampleTodos,
      totalCount: 1,
      currentPage: 1,
      pageSize: 20,
      hasMore: false,
    );

    setUp(() {
      mockRepository = MockTodoRepository();
      todoBloc = TodoBloc(repository: mockRepository);
    });

    tearDown(() {
      todoBloc.close();
    });

    test('initial state is TodoInitial', () {
      expect(todoBloc.state, equals(TodoInitial()));
    });

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] when LoadInitial succeeds',
      build: () {
        when(() => mockRepository.getTodos(
              page: 1,
              pageSize: 20,
              filter: TodoFilter.all,
            )).thenAnswer((_) async => sampleResponse);
        return todoBloc;
      },
      act: (bloc) => bloc.add(LoadInitial()),
      expect: () => [
        TodoLoading(),
        TodoLoaded(sampleResponse, currentFilter: TodoFilter.all),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] when SearchTodos is added',
      build: () {
        when(() => mockRepository.getTodos(
              page: 1,
              pageSize: 20,
              searchQuery: 'test',
              filter: TodoFilter.all,
            )).thenAnswer((_) async => sampleResponse);
        return todoBloc;
      },
      seed: () => TodoLoaded(sampleResponse, currentFilter: TodoFilter.all),
      act: (bloc) => bloc.add(const SearchTodos('test')),
      wait: const Duration(milliseconds: 400),
      skip: 1,
      expect: () => [isA<TodoLoaded>()],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] when ApplyFilters is added',
      build: () {
        when(() => mockRepository.getTodos(
              page: 1,
              pageSize: 20,
              filter: TodoFilter.active,
            )).thenAnswer((_) async => sampleResponse);
        return todoBloc;
      },
      act: (bloc) => bloc.add(const ApplyFilters(TodoFilter.active)),
      expect: () => [
        TodoLoading(),
        TodoLoaded(sampleResponse, currentFilter: TodoFilter.active),
      ],
    );
  });
}

