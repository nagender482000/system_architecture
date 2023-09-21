import 'package:flutter/material.dart';

// Model
class Todo {
  final String title;
  bool isCompleted;

  Todo({
    required this.title,
    required this.isCompleted,
  });
}

// View
class TodoView extends StatefulWidget {
  const TodoView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TodoController controller;

  @override
  TodoViewState createState() => TodoViewState();
}

class TodoViewState extends State<TodoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: ListView.builder(
        itemCount: widget.controller.todos.length,
        itemBuilder: (context, index) {
          final todo = widget.controller.todos[index];

          return CheckboxListTile(
            title: Text(todo.title),
            value: todo.isCompleted,
            onChanged: (value) {
              widget.controller.toggleTodo(index);
              // Remove setstate
              setState(() {});
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.controller.addTodo();
          // Remove setstate
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Controller
class TodoController {
  final List<Todo> todos;

  TodoController({required this.todos});

  void addTodo() {
    todos.add(Todo(title: '', isCompleted: false));
    //TO DO: Updating the view state
  }

  void toggleTodo(int index) {
    todos[index].isCompleted = !todos[index].isCompleted;
    //TO DO: Updating the view state
  }
}

void main() {
  runApp(MaterialApp(
    home: TodoView(
      controller: TodoController(todos: []),
    ),
  ));
}
