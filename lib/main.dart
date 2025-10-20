import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_project/bloc/todo_bloc.dart';
import 'package:interview_project/models/todo_filter.dart';

import 'repositories/mock_todo_repository.dart';
import 'repositories/todo_repository.dart';

void main() {
  // Initialize the mock repository with 1000 random todos
  final TodoRepository todoRepository = MockTodoRepository(count: 1000);

  runApp(MyApp(todoRepository: todoRepository));
}

class MyApp extends StatelessWidget {
  final TodoRepository todoRepository;

  const MyApp({super.key, required this.todoRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: todoRepository,
      child: BlocProvider(
        create: (context) =>
            TodoBloc(repository: todoRepository)..add(LoadInitial()),
        child: MaterialApp(
          title: 'Todo Interview Project',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: const TodoListScreen(),
        ),
      ),
    );
  }
}

/// Placeholder widget - This is where you'll implement your solution
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TodoListScreenState();

}

class _TodoListScreenState extends State<TodoListScreen>{

final ScrollController _scrollController = ScrollController();
bool _isLoadingMore = false;

@override
void initState() {
  super.initState();
  _scrollController.addListener(_onScroll);
}

void _onScroll(){
  final bloc = context.read<TodoBloc>();
  final state = bloc.state;
  if(state is TodoLoaded && state.response.hasMore && !_isLoadingMore){
    if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent *.9){
      setState(() {
        _isLoadingMore = true;
      });
      bloc.add(LoadPage(state.response.currentPage+1));
    }
  }
}



void _onSearchChanged(String query){
  context.read<TodoBloc>().add(SearchTodos(query));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoaded) {
            // Reset loading flag after a short delay to keep spinner visible
            if (_isLoadingMore) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                // Keep spinner visible for at least 800ms for better UX
                await Future.delayed(const Duration(milliseconds: 800));
                if (mounted) {
                  setState(() {
                    _isLoadingMore = false;
                  });
                }
              });
            }
          }
          
          return switch (state) {
            TodoInitial() => const Center(child: CircularProgressIndicator(),),
            TodoLoading() => const Center(child: CircularProgressIndicator(),),
            TodoFailure(messsage: final message) => Center(child: Text('error $message')),
            TodoLoaded(response: final response, currentFilter: final filter) =>
              Column(
                children: [
                  Padding(padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(child: TextField(decoration: InputDecoration(hintText: 'search...'),
                      onChanged: _onSearchChanged,)),
                    const SizedBox (width: 10),
                    DropdownButton(
                      value: filter,
                      items: TodoFilter.values
                              .map(
                                (f) => DropdownMenuItem(
                                  value: f,
                                  child: Text(f.name),
                                ),
                              )
                              .toList(), 
                      onChanged: (value)=> context.read<TodoBloc>().add(ApplyFilters(value)),)
                    ],
                  ),),
                  Expanded(child: ListView.builder(
                    controller: _scrollController,
                    itemCount: response.items.length + (_isLoadingMore && response.hasMore ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == response.items.length) {
                        // Show spinner at bottom when loading more
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final todo = response.items[index];
                      return ListTile(
                        title: Text(todo.title),
                        subtitle: Text(todo.description),
                        trailing:Text(todo.isActive ? 'active' : 'inactive'),
                      );
                    },
                  ),)
                ],
              )
          };
        },
      )
    );
  }
}
