part of 'todo_bloc.dart';

sealed class TodoState extends Equatable {
  const TodoState();
  
  @override
  List<Object> get props => [];
}

final class TodoInitial extends TodoState {}
final class TodoLoading extends TodoState {}

final class TodoFailure extends TodoState {
  final String messsage;
  const TodoFailure(this.messsage);
  @override
  List<Object> get props => [messsage];
}

final class TodoLoaded extends TodoState {
  final PaginatedResponse<Todo>  response;
  final TodoFilter currentFilter;
  const TodoLoaded(this.response, {this.currentFilter= TodoFilter.all});
  @override
  List<Object> get props => [response];
}