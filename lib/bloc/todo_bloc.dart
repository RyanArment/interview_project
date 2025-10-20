import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:interview_project/models/paginated_response.dart';
import 'package:interview_project/models/todo.dart';
import 'package:interview_project/models/todo_filter.dart';
import 'package:interview_project/repositories/todo_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;
  static const int _pageSize = 20;

  TodoBloc({required this.repository}) : super(TodoInitial()) {
    on<LoadInitial>(_onLoadInitial);
    on<LoadPage>(_onLoadPage);
    
  
    on<SearchTodos>(
      _onSearchTodos,
      transformer: _debounceTransformer(const Duration(milliseconds: 300)),
    );
    on<ApplyFilters>(_onApplyFilters);
  }

  /// D E B O U N C E  E V E N T  T R A N S F O R M E R
  EventTransformer<T> _debounceTransformer<T>(Duration duration) {
    return (events, mapper) => events.debounce(duration).switchMap(mapper);
  }

  Future<void> _onLoadInitial(
    LoadInitial event,
    Emitter<TodoState> emit,
  ) async {
    await _loadTodos(emit, page: 1, filter: TodoFilter.all);
  }

  Future<void> _onLoadPage(LoadPage event, Emitter<TodoState> emit) async {
    final current = state;
    if (current is! TodoLoaded) return;
    
    await _loadTodos(
      emit,
      page: event.page,
      filter: current.currentFilter,
      showLoading: false,
      mergeWithExisting: true,
    );
  }

  Future<void> _onSearchTodos(
    SearchTodos event,
    Emitter<TodoState> emit,
  ) async {
    final current = state;
    final currentFilter = current is TodoLoaded
        ? current.currentFilter
        : TodoFilter.all;

    await _loadTodos(
      emit,
      page: 1,
      searchQuery: event.query.isEmpty ? null : event.query,
      filter: currentFilter,
      showLoading: true, 
    );
  }

  Future<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<TodoState> emit,
  ) async {
    await _loadTodos(emit, page: 1, filter: event.filter ?? TodoFilter.all);
  }

  Future<void> _loadTodos(
    Emitter<TodoState> emit, {
    required int page,
    String? searchQuery,
    TodoFilter filter = TodoFilter.all,
    bool showLoading = true,
    bool mergeWithExisting = false,
  }) async {
    /// S H O W  L O A D I N G  W H E E L
    if (showLoading) {
      emit(TodoLoading());
    }

    try {
      final response = await repository.getTodos(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
        filter: filter,
      );

      final finalResponse = mergeWithExisting && state is TodoLoaded
          ? PaginatedResponse(
              items: [
                ...(state as TodoLoaded).response.items,
                ...response.items
              ],
              totalCount: response.totalCount,
              currentPage: response.currentPage,
              pageSize: response.pageSize,
              hasMore: response.hasMore,
            )
          : response;

      emit(TodoLoaded(finalResponse, currentFilter: filter));
    } catch (e) {
      emit(TodoFailure(e.toString()));
    }
  }
}
