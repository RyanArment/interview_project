import 'package:equatable/equatable.dart';

/// Represents a paginated response from the API
class PaginatedResponse<T> extends Equatable {
  final List<T> items;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final bool hasMore;

  const PaginatedResponse({
    required this.items,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [
    items,
    totalCount,
    currentPage,
    pageSize,
    hasMore,
  ];

  @override
  String toString() {
    return 'PaginatedResponse(items: ${items.length}, totalCount: $totalCount, currentPage: $currentPage, hasMore: $hasMore)';
  }
}
