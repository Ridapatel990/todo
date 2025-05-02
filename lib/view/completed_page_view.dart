import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/business_logic/todo_model_provider.dart';
import 'package:todo_app/widgets/new_todo_card.dart';

class CompletedPageView extends StatelessWidget {
  const CompletedPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todoVM = Provider.of<TodoModelView>(context);
    final completedTodos =
        todoVM.todos.where((todo) => todo.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Completed Todos')),
      body:
          completedTodos.isEmpty
              ? Center(
                child: Text(
                  'No completed todos yet!',
                  style: theme.textTheme.titleLarge,
                ),
              )
              : ListView.builder(
                itemCount: completedTodos.length,
                itemBuilder: (context, index) {
                  final todo = completedTodos[index];
                  return NewTodoCard(todoModel: todo);
                },
              ),
    );
  }
}
