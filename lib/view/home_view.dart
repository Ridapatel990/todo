import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/business_logic/todo_model_provider.dart';
import 'package:todo_app/widgets/new_todo_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Todos')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Optional: Add a small heading or space
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Expanded list
            Expanded(
              child: Consumer<TodoModelView>(
                builder: (context, todoModelView, _) {
                  if (todoModelView.todos.isEmpty) {
                    return const Center(child: Text('No Todos Yet 📝'));
                  }
                  return ListView.builder(
                    itemCount: todoModelView.todos.length,
                    itemBuilder: (context, index) {
                      final todo = todoModelView.todos[index];
                      return NewTodoCard(todoModel: todo);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your createTodo function call or open add todo page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
