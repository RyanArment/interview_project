import 'package:equatable/equatable.dart';

/// Represents a Todo item
class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isActive;
  final DateTime createdAt;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, description, isActive, createdAt];

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, isActive: $isActive)';
  }
}
