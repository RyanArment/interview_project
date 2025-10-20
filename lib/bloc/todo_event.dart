part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

final class LoadInitial extends TodoEvent{}

final class LoadPage extends TodoEvent {
  final int page;
  const LoadPage(this.page);
  @override
  List<Object> get props => [page];
}

final class SearchTodos extends TodoEvent {
  final String query;
  const SearchTodos(this.query);
  @override
  List<Object> get props => [query];
}

final class ApplyFilters extends TodoEvent {
  final TodoFilter? filter;
  const ApplyFilters(this.filter);
  @override
  List<Object> get props => [filter?? TodoFilter.all];
}