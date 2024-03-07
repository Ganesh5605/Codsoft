import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoList(),

      child: MaterialApp(
        title: 'Add Todo List',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: TodoListScreen(),
      ),
    );
  }
}

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List App'),
      ),
      body: TodoListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoScreen()),
          );
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoList>(
      builder: (context, todoList, child) {
        return ListView.builder(
          itemCount: todoList.todos.length,
          itemBuilder: (context, index) {
            final todo = todoList.todos[index];
            return ListTile(
              title: Text(todo.title),
              leading: Checkbox(
                value: todo.completed,
                onChanged: (value) {
                  todoList.toggleTodoStatus(todo);
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  todoList.removeTodo(todo);
                },

              ),
            );
          },
        );
      },
    );
  }
}

class AddTodoScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star_outline),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Todo Name",
                    hintStyle: TextStyle(color: Colors.blueAccent),
                    //prefixIcon: Icon(Icons.height),
                  ),

                  keyboardType: TextInputType.number,
                ),
              ],
            ),

            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  Provider.of<TodoList>(context, listen: false)
                      .addTodo(Todo(title: _controller.text));
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        ),

      ),
    );
  }
}

class TodoList extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void toggleTodoStatus(Todo todo) {
    todo.completed = !todo.completed;
    notifyListeners();
  }

  void removeTodo(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
  }
}

class Todo {
  final String title;
  bool completed;

  Todo({
    required this.title,
    this.completed = false,
  });
}
